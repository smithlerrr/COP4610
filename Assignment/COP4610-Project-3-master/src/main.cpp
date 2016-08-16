#include <iostream>
#include <string>
#include <vector>
#include <utility>
#include <string.h>
#include <fstream>
#include <stdint.h> //Ints
#include <unistd.h> //UNIX Stuff
#include <sys/mman.h> //Mmap
#include <fcntl.h> //Open
#include <sys/stat.h>

//Definitions
#define EMPTY_ENTRY 0xE5
#define LAST_ENTRY 0x00
#define ATTR_READ_ONLY 0x01
#define ATTR_HIDDEN 0x02 
#define ATTR_SYSTEM 0x04
#define ATTR_VOLUME_ID 0x08 
#define ATTR_DIRECTORY 0x10 
#define ATTR_ARCHIVE 0x20
#define ATTR_LONG_NAME 0x0F
#define EMPTY_CLUSTER 0x0000000
#define EOC 0x0FFFFFF8

using namespace std;

struct BIOSParameterBlock{
	uint16_t BytsPerSec;
	uint8_t SecPerClus;
	uint16_t RsvdSecCnt;
	uint8_t NumFATs;
	uint32_t TotSec32;
	uint32_t FATSz32;
	uint32_t RootClus;
	uint16_t FSInfo;
};

struct FileSystemInfo{
	uint32_t FreeCount;
	uint32_t NxtFree;
};

struct DIRStruct{
	char Name[12];
	uint8_t Attrib;
	uint16_t FstClusHI;
	uint16_t FstClusLO;
	uint32_t FileSize; 
};

//Functions
template<typename T> T ParseInteger(const uint8_t* const ptr);
template<typename T> int WriteInteger(uint8_t* const ptr, T val);
int ReadBPB();
int ReadFSInfo();
int toArgs();
void clearArgs();
DIRStruct ReadDIR(uint32_t sector);
size_t imageSize(const char* filename);
int FirstSectorOfCluster(uint32_t cluster);
uint32_t GetClusterOfDIR(uint32_t cluster, const char *name);
uint32_t GetClusterOfFile(uint32_t cluster, const char *file);
uint32_t FAT(uint32_t cluster);
bool fileIsOpen(char* filename);
string fileMode(char* filename);
bool dirHasFiles(uint32_t cluster);


//Command Functions
int fsinfo();
int mopen(char* filename, char* args);
int mclose(char* fliename);
int create(char* file);
int read(char* file, uint32_t start_pos, uint32_t num_bytes);
int rm(char* file);
int ls(uint32_t cluster);
int cd(char* newDir);
int mkdir(char* dir);
int rmdir(char* dir);
uint32_t fileSize(char* file);

//Globals
uint8_t* image;
BIOSParameterBlock BPB;
FileSystemInfo FSInfo;
uint32_t FirstDataSector;
uint32_t RootClusterSector;
uint32_t currentDIRcluster;
string currentDIRstring;
char *args[100];
char command[255];
int func_return;
vector<pair<string, string>> openfiles;

int main(int argc, char* argv[]){
	//string command;
	//fstream image;
	//BIOSParameterBlock BPB;
	DIRStruct DIR;
	
	if(argc != 2){
		cout << "Usage: fat32util <fat32 image>" << endl;
		return 1;
	}
	
	size_t size = imageSize(argv[1]);

	auto imageDescriptor = open(argv[1], O_RDWR);
	
	if(imageDescriptor < 0){
		cout << "Could not open " << argv[1] << endl;
		return 2;
	}

	int offset = 0; 
	unsigned len = 4096; 
	image = (uint8_t*)mmap(0, size, PROT_READ | PROT_WRITE, MAP_SHARED, imageDescriptor, offset);

	//Read BPB
	ReadBPB();
	ReadFSInfo();

	//Get FirstDataSector and RootClusterSector
	FirstDataSector = BPB.RsvdSecCnt + (BPB.NumFATs * BPB.FATSz32);
	RootClusterSector = ((BPB.RootClus - 2) * BPB.SecPerClus) + FirstDataSector;

	//cout << "FirstDataSector: " << FirstDataSector << endl << "RootClusterSector: " << RootClusterSector << endl;

	//Set currentDIR to root
	currentDIRstring = "/";
	currentDIRcluster = BPB.RootClus;
	
	offset = RootClusterSector*BPB.BytsPerSec;

	//cout << "Offset: " << offset << endl;
	//cout << "Root DIR:" << endl;
	//cout << "While offset < " << RootClusterSector*BPB.BytsPerSec + BPB.BytsPerSec*BPB.SecPerClus << endl;
	
	//ls(RootClusterSector);
	//cd("RED");
	//ls(FirstSectorOfCluster(currentDIRcluster));
	


	while(strcmp(command, "QUIT") != 0){
		clearArgs();
		msync(image, size, MS_SYNC);
		command[0] = '\0';

		cout << "$:[" + currentDIRstring + "]>";
		fgets(command, 255, stdin);
		for(int i = 0; i < 255; i++)
			command[i] = toupper(command[i]);
		toArgs();
		if(strcmp(command, "FSINFO") == 0){
			fsinfo();
		}
		else if(strcmp(command, "OPEN") ==0){
			mopen(args[1], args[2]);
		}
		else if(strcmp(command, "CLOSE") ==0){
			mclose(args[1]);
		}
		else if(strcmp(command, "CREATE") == 0){
			create(args[1]);
		}
		else if(strcmp(command, "READ") == 0){
			if(!(args[1] && args[2] && args[3])){
				cout << "Error: Usage is: read <file> <start_pos> <num_bytes>" << endl;
			}
			else{
				func_return = read(args[1], atoi(args[2]), atoi(args[3]));
				//cout << func_return << endl;
			}
		}
		else if(strcmp(command, "RM") == 0){ 
			rm(args[1]);
		}
		else if(strcmp(command, "LS") == 0){
			ls(currentDIRcluster);
		}
		else if(strcmp(command, "CD") == 0){ 
			cd(args[1]);
		}		
		else if(strcmp(command, "MKDIR") == 0){ 
			mkdir(args[1]);
		}
		else if(strcmp(command, "RMDIR") == 0){ 
			rmdir(args[1]);
		}
		else if(strcmp(command, "SIZE") == 0){ 
			cout << fileSize(args[1]) << endl;
		}
	}

	munmap(image, size);

	return 0;
}

template<typename T> T ParseInteger(const uint8_t* const ptr){
	T val = 0;  
	for (size_t i=0; i<sizeof(T); ++i) {
         	val |= static_cast<T>(static_cast<T>(ptr[i]) << (i*8));
    	}  
    	return val; 
}

template<typename T> int WriteInteger(uint8_t* const ptr, T val){
	for (size_t i=sizeof(T); i>0; --i) {
		//cout << "i-1=" << i-1 << endl;
		ptr[i-1] = uint8_t(val >> ((i-1)*8));
	}  
	return 0; 
}

int ReadBPB(){
	BPB.BytsPerSec = ParseInteger<uint16_t>(image + 11);
	BPB.SecPerClus = ParseInteger<uint8_t>(image + 13);
	BPB.RsvdSecCnt = ParseInteger<uint16_t>(image + 14);
	BPB.NumFATs = ParseInteger<uint8_t>(image + 16);
	BPB.TotSec32 = ParseInteger<uint32_t>(image + 32);
	BPB.FATSz32 = ParseInteger<uint32_t>(image + 36);
	BPB.RootClus = ParseInteger<uint32_t>(image + 44);
	BPB.FSInfo = ParseInteger<uint16_t>(image + 48);
	return 0;
}

int ReadFSInfo(){
	FSInfo.FreeCount = ParseInteger<uint32_t>(image+(BPB.FSInfo*BPB.BytsPerSec)+488);
	FSInfo.NxtFree = ParseInteger<uint32_t>(image+(BPB.FSInfo*BPB.BytsPerSec)+492);
}

DIRStruct ReadDIR(uint32_t sector){
	DIRStruct DIR;
	char rchar;
	uint32_t i;
	uint32_t j;

	for(i = 0; i < 8; i++){
		if(i == 0){
			if(ParseInteger<uint8_t>(image + sector + i) == EMPTY_ENTRY){
				DIR.Name[0] = EMPTY_ENTRY;
				DIR.Name[1] = '\0';
				break;
			}
		}
		rchar = (char)ParseInteger<uint8_t>(image + sector + i);
		if(rchar == ' '){
			DIR.Name[i] = '\0';
			break;
		}

		DIR.Name[i] = rchar;
	}

	if(i == 8)
		DIR.Name[8] = '\0';

	for(j = 8; j < 11; j++){
		rchar = (char)ParseInteger<char>(image + sector + j);
		if(rchar == ' '){
			if(j == 8)
				break;
			else{
				DIR.Name[i] = '\0';
				break;
			}
		
		}
		if(j == 8){
			DIR.Name[i] = '.';
			i++;
		}
		DIR.Name[i] = rchar;
		i++;
	}

	DIR.Attrib = ParseInteger<uint8_t>(image+sector+0x0B);
	DIR.FstClusHI = ParseInteger<uint16_t>(image+sector+0x14);
	DIR.FstClusLO = ParseInteger<uint16_t>(image+sector+0x1A);
	DIR.FileSize = ParseInteger<uint32_t>(image+sector+0x1C);
	return DIR;
}

int WriteDIR(DIRStruct DIR, int offset){
	for(int i = 0; i < 11; i++){
		WriteInteger<char>(image+offset+i, DIR.Name[i]);
	}
	//cout << "Wrote Name: " << DIR.Name << " at offset = " << offset << endl;

	DIR.Attrib = WriteInteger<char>(image+offset+0x0B, DIR.Attrib);
	DIR.FstClusHI = WriteInteger<uint16_t>(image+offset+0x14, DIR.FstClusHI);
	DIR.FstClusLO = WriteInteger<uint16_t>(image+offset+0x1A, DIR.FstClusLO);
	DIR.FileSize = WriteInteger<uint32_t>(image+offset+0x1C, DIR.FileSize);
	return 0;
}

int fsinfo(){
	cout << "Bytes per sector: "<< BPB.BytsPerSec << endl << "Sectors per cluster: " << int(BPB.SecPerClus) << endl << "Total sectors: " << BPB.TotSec32 << endl << "Number of FATs: " << int(BPB.NumFATs) << endl << "Sectors per FAT: " << BPB.FATSz32 << endl << "Number of free sectors: " << FSInfo.FreeCount << endl;
	return 0;
}

int create(char* file){
	uint32_t filecluster;
	uint32_t cluster;
	uint32_t offset;
	uint32_t sector;
	bool last_entry = false;
	DIRStruct newDIRentry;
	DIRStruct tempDIR;

	cluster = currentDIRcluster;

	if(strlen(file) > 11){
		cout << "Error! File name too long." << endl;
		return -2;
	}

	filecluster = FSInfo.NxtFree;

	while(cluster < EOC){
		sector = FirstSectorOfCluster(cluster);
		offset = sector*BPB.BytsPerSec;
		while(offset < (sector*BPB.BytsPerSec + BPB.BytsPerSec*BPB.SecPerClus)){

			if(last_entry == true){
				WriteDIR(tempDIR, offset);
				break;
			}		
		
			newDIRentry = ReadDIR(offset);


			if(strcmp(newDIRentry.Name, file)==0){
				cout << "Error! File already exists." << endl;
				return -1;
			}
	
			if(newDIRentry.Name[0] == LAST_ENTRY){
				//Add file
				last_entry = true;
				tempDIR = newDIRentry;
				int j = 0;
				for(int i = 0; i < 11; i++){					
					if(file[i] == '.'){
						j = 8;
					}
					else{
						newDIRentry.Name[j] = file[i];
						j++;
						if(file[i] == '\0')
							break;
					}
				}
				newDIRentry.Attrib = ATTR_ARCHIVE;
				newDIRentry.FstClusHI = (filecluster>>16);
				newDIRentry.FstClusLO = (filecluster & 0x0000FFFF);
				newDIRentry.FileSize = 0;
				WriteDIR(newDIRentry, offset);
				//cout << "Created file: " << newDIRentry.Name << endl;
			}
				

			offset += 32;
		}
		cluster = FAT(cluster); 
	}

	//Update FAT
	offset=BPB.RsvdSecCnt*BPB.BytsPerSec + filecluster*4; 
		WriteInteger<uint32_t>(image+offset, EOC); 
	
	cluster = 0x00000002;
	while(FAT(cluster) != 0x00000000){
		cluster++;
	}
	//Update FSInfo.NxtFree
	WriteInteger<uint32_t>(image+(BPB.FSInfo*BPB.BytsPerSec)+492, cluster);
	WriteInteger<uint32_t>(image+(BPB.FSInfo*BPB.BytsPerSec)+488, (FSInfo.FreeCount-1));
	ReadFSInfo();
	//cout << "FSInfo.NxtFree: " << FSInfo.NxtFree << endl;
	
	return 0;
}

int read(char* file, uint32_t start_pos, uint32_t num_bytes){
	int offset;
	uint32_t cluster;
	uint32_t i;

	i = 0;

	cluster = GetClusterOfFile(currentDIRcluster, file);

	if(!(fileIsOpen(file))){
		cout << "File is not open." << endl;
		return -2;
	}
	
	if(fileMode(file) == "W"){
		cout << "File is only open for writing." << endl;
		return -3;
	}

	while(cluster < EOC && i < num_bytes){
		//cout << "Entered loop" << endl;
		offset = FirstSectorOfCluster(cluster)*BPB.BytsPerSec + start_pos;
		//cout << "offset less than: " << FirstSectorOfCluster(cluster)*BPB.BytsPerSec + BPB.BytsPerSec*BPB.SecPerClus << endl;
		while(offset < (FirstSectorOfCluster(cluster)*BPB.BytsPerSec + BPB.BytsPerSec*BPB.SecPerClus)){
			cout << image[offset];
			offset += 1;
			//cout << "offset: " << offset << endl;
			i++;
			if(i >= num_bytes){
				cout << endl;
				return 0;
			}
		}
		cluster = FAT(cluster);
		if(cluster >= EOC){
			cout << endl;
			return -1;
		}
	}
	cout << endl;
	return 0;
}

int rm(char* file){
	int offset;
	uint32_t nextCluster;
	uint32_t cluster = currentDIRcluster;
	while(cluster < EOC){
		offset = FirstSectorOfCluster(cluster)*BPB.BytsPerSec;
		while(offset < (FirstSectorOfCluster(cluster)*BPB.BytsPerSec + BPB.BytsPerSec*BPB.SecPerClus)){
	
			DIRStruct currentDIR = ReadDIR(offset);

			if(strcmp(currentDIR.Name, file) == 0){
				if(currentDIR.Attrib == ATTR_DIRECTORY){
					cout << "Error: " << file << " is a directory!" << endl;
					break;
				}
				cluster = GetClusterOfFile(currentDIRcluster, file);
				WriteInteger<char>(image+offset, (char)EMPTY_ENTRY);
				WriteInteger<char>(image+offset+1, '\0');
				for(int j = 2; j < 11; j++){
					WriteInteger<char>(image+offset+j, ' ');
				}
				//cout << "clsuter: " << cluster << endl;
				uint32_t i = 0;
				while(cluster < EOC && cluster != 0){
					i++;
					nextCluster = FAT(cluster);
				 	offset=BPB.RsvdSecCnt*BPB.BytsPerSec + cluster*4; 
					WriteInteger<uint32_t>(image+offset, EMPTY_CLUSTER);
				 	cluster = nextCluster;
					//cout << "cluster: " << cluster << endl;
				}
				//cout << "FSInfo.FreeCount: " << FSInfo.FreeCount << endl;
				FSInfo.FreeCount += i;
				//cout << i << endl;
				//cout << "FSInfo.FreeCount: " << FSInfo.FreeCount << endl;
				return 0;
			}

			else if(currentDIR.Name[0] == LAST_ENTRY){
				cout << "Error: File does not exist!" << endl;
				return -1;
			}

			offset += 32;	
		}
		cluster = FAT(cluster);
	}
	return -1;
}

int rmdir(char* dir){
	int offset;
	uint32_t nextCluster;
	uint32_t cluster = currentDIRcluster;

	while(cluster < EOC){
		offset = FirstSectorOfCluster(cluster)*BPB.BytsPerSec;
		while(offset < (FirstSectorOfCluster(cluster)*BPB.BytsPerSec + BPB.BytsPerSec*BPB.SecPerClus)){
	
			DIRStruct currentDIR = ReadDIR(offset);

			if(strcmp(currentDIR.Name, dir) == 0){
				if(currentDIR.Attrib != ATTR_DIRECTORY){
					cout << "Error: " << dir << " is not a directory!" << endl;
					return -1;
				}
				
				if(dirHasFiles(GetClusterOfDIR(currentDIRcluster, dir))){
					cout << "Error: Directory is not empty." << endl;
					return -2;
				}

				cluster = GetClusterOfDIR(currentDIRcluster, dir);
				WriteInteger<char>(image+offset, (char)EMPTY_ENTRY);
				WriteInteger<char>(image+offset+1, '\0');
				for(int j = 2; j < 11; j++){
					WriteInteger<char>(image+offset+j, ' ');
				}
				//cout << "clsuter: " << cluster << endl;
				uint32_t i = 0;
				while(cluster < EOC && cluster != 0){
					i++;
					nextCluster = FAT(cluster);
				 	offset=BPB.RsvdSecCnt*BPB.BytsPerSec + cluster*4; 
					WriteInteger<uint32_t>(image+offset, EMPTY_CLUSTER);
				 	cluster = nextCluster;
					//cout << "cluster: " << cluster << endl;
				}
				//cout << "FSInfo.FreeCount: " << FSInfo.FreeCount << endl;
				FSInfo.FreeCount += i;
				//cout << i << endl;
				//cout << "FSInfo.FreeCount: " << FSInfo.FreeCount << endl;
				return 0;
					
			}
			offset += 32;	
		}
		cluster = FAT(cluster);
	}
	return -1;
}

int mkdir(char* dir){
	uint32_t filecluster;
	uint32_t cluster;
	uint32_t offset;
	uint32_t sector;
	bool last_entry = false;
	DIRStruct newDIRentry;
	DIRStruct tempDIR;

	cluster = currentDIRcluster;

	if(strlen(dir) > 11){
		cout << "Error! Directory name too long." << endl;
		return -2;
	}

	filecluster = FSInfo.NxtFree;

	while(cluster < EOC){
		sector = FirstSectorOfCluster(cluster);
		offset = sector*BPB.BytsPerSec;
		while(offset < (sector*BPB.BytsPerSec + BPB.BytsPerSec*BPB.SecPerClus)){

			if(last_entry == true){
				WriteDIR(tempDIR, offset);
				break;
			}		
		
			newDIRentry = ReadDIR(offset);


			if(strcmp(newDIRentry.Name, dir)==0){
				cout << "Error! File/Directory already exists." << endl;
				return -1;
			}
	
			if(newDIRentry.Name[0] == LAST_ENTRY){
				//Add file
				last_entry = true;
				tempDIR = newDIRentry;
				int j = 0;
				for(int i = 0; i < 11; i++){					
					newDIRentry.Name[j] = dir[i];
					j++;
					if(dir[i] == '\0')
						break;
				}
				newDIRentry.Attrib = ATTR_DIRECTORY;
				newDIRentry.FstClusHI = (filecluster>>16);
				newDIRentry.FstClusLO = (filecluster & 0x0000FFFF);
				newDIRentry.FileSize = 0;
				WriteDIR(newDIRentry, offset);
				//cout << "Created file: " << newDIRentry.Name << endl;
			}
				

			offset += 32;
		}
		cluster = FAT(cluster); 
	}

	//Update FAT
	offset=BPB.RsvdSecCnt*BPB.BytsPerSec + filecluster*4; 
		WriteInteger<uint32_t>(image+offset, EOC); 
	
	cluster = 0x00000002;
	while(FAT(cluster) != 0x00000000){
		cluster++;
	}
	//Update FSInfo.NxtFree
	WriteInteger<uint32_t>(image+(BPB.FSInfo*BPB.BytsPerSec)+492, cluster);
	WriteInteger<uint32_t>(image+(BPB.FSInfo*BPB.BytsPerSec)+488, (FSInfo.FreeCount-1));
	ReadFSInfo();
	//cout << "FSInfo.NxtFree: " << FSInfo.NxtFree << endl;

	sector = FirstSectorOfCluster(filecluster);
	offset = sector*BPB.BytsPerSec;

	WriteInteger<uint32_t>(image+offset, LAST_ENTRY);
	
	return 0;
}

bool dirHasFiles(uint32_t cluster){
	uint32_t sector;
	int offset;
	int i = 0;

	while(cluster < EOC){
		sector = FirstSectorOfCluster(cluster);
		offset = sector*BPB.BytsPerSec;
		while(offset < (sector*BPB.BytsPerSec + BPB.BytsPerSec*BPB.SecPerClus)){		
		
			DIRStruct currentDIR = ReadDIR(offset);
	
			if(currentDIR.Name[0] == LAST_ENTRY){
				//cout << "i = " << i << endl;
				if(i == 0)
					return false;
				return true;
			}

			if((currentDIR.Attrib != ATTR_LONG_NAME) && (currentDIR.Name[0] != (char)EMPTY_ENTRY)&& (currentDIR.Name[0] != '.'))
				i++;

			offset += 32;
		}
		cluster = FAT(cluster); 
	}
	return true;
}

int ls(uint32_t cluster){
	uint32_t sector;
	int offset;

	while(cluster < EOC){
		sector = FirstSectorOfCluster(cluster);
		offset = sector*BPB.BytsPerSec;
		while(offset < (sector*BPB.BytsPerSec + BPB.BytsPerSec*BPB.SecPerClus)){		
		
			DIRStruct currentDIR = ReadDIR(offset);
	
			if(currentDIR.Name[0] == LAST_ENTRY){
				break;
			}

			if((currentDIR.Attrib != ATTR_LONG_NAME) && (currentDIR.Name[0] != (char)EMPTY_ENTRY))
				cout << "`" << currentDIR.Name << "`" << endl;

			offset += 32;
		}
		cluster = FAT(cluster); 
	}
	return 0;
}

int cd(char* newDIR){
	uint32_t newDIRcluster;

	newDIRcluster = GetClusterOfDIR(currentDIRcluster, newDIR);
	if(newDIRcluster == 0){
		cout << "Error: Directory not found" << endl;
		return 1;
	}
	else{
		currentDIRcluster = newDIRcluster;
		if(strcmp(newDIR, "..") == 0){
			currentDIRstring.erase(currentDIRstring.rfind('/'));
			currentDIRstring.erase(currentDIRstring.rfind('/') + 1);
		}
		else if(strcmp(newDIR, ".") != 0)
			currentDIRstring = currentDIRstring + newDIR + '/';
		return 0;
	}
	

	return 1;
}

int mopen(char* filename, char* args)
{
struct DIRStruct currentDIR;
int offset;
int sector;
uint32_t size;
uint32_t cluster;

cluster= currentDIRcluster;
	while(cluster < EOC){
		sector=FirstSectorOfCluster(cluster);
		offset=sector*BPB.BytsPerSec;
		while(offset < (sector*BPB.BytsPerSec + BPB.BytsPerSec*BPB.SecPerClus))
		{
			currentDIR = ReadDIR(offset);
			if(currentDIR.Name[0] == EMPTY_ENTRY)
				continue;
			else if(currentDIR.Name[0] == LAST_ENTRY){
				cout << "File not found." << endl;
				return -1;
			}
			if(strcmp(currentDIR.Name, filename)==0)
			{
				string File(filename);
				string pathname =currentDIRstring+File;
				//Check if already open
				if(fileIsOpen(filename)){
					cout << "File already open." << endl;
					return -3;
				}
				string perm = args;
				openfiles.push_back(make_pair(pathname, perm));
				string pword;
				if(perm=="W")
					pword="write-only";
				else if(perm=="R")
					pword="read-only";
				else if(perm=="RW")
					pword="read-write";
				else{
					cout << "Invalid permission." << endl;
					return -2;
				}
				cout<<filename <<" has been opened with " <<pword<<" permission."<<endl;
				return 0;
			}
			offset += 32;
		}
		cluster = FAT(cluster);
	}
}

int mclose(char* filename)
{
string File(filename);
for(vector<pair<string, string>>::iterator it = openfiles.begin(); it !=openfiles.end(); it++)
	{
	if(it->first==(currentDIRstring + File))
		{
		openfiles.erase(it);
		cout<<filename<<" is now closed."<<endl;
		return 0;
		}

	}
cout << "File couldn't be found in the open file table." << endl;

}

bool fileIsOpen(char* filename){
string File(filename);
for(vector<pair<string, string>>::iterator it = openfiles.begin(); it !=openfiles.end(); it++)
	{
	if(it->first==(currentDIRstring + File))
		{
		return true;
		}

	}
return false;
}

string fileMode(char* filename){
string File(filename);
for(vector<pair<string, string>>::iterator it = openfiles.begin(); it !=openfiles.end(); it++)
	{
	if(it->first==(currentDIRstring + File))
		{
		return it->second;
		}

	}
return "Error";
}

uint32_t fileSize(char* file){
	struct DIRStruct currentDIR;
	int offset; 
	uint32_t size;
	int sector;
	uint32_t cluster;

	cluster = currentDIRcluster;
	
	while(cluster < EOC){
		sector = FirstSectorOfCluster(cluster);
		offset = sector*BPB.BytsPerSec;
		while(offset < (sector*BPB.BytsPerSec + BPB.BytsPerSec*BPB.SecPerClus)){
			currentDIR = ReadDIR(offset);
			if (currentDIR.Name[0] == EMPTY_ENTRY) 
				continue; 
			else if (currentDIR.Name[0] == LAST_ENTRY) 
				break; 
			if (currentDIR.Attrib != ATTR_LONG_NAME) {
				//cout << "Name: " << currentDIR.Name << endl;
				if(strcmp(currentDIR.Name, file)==0){
					size = currentDIR.FileSize;
					return size;
				}
			}
			offset+=32;
		} 
 		cluster = FAT(cluster); 
	}
}


size_t imageSize(const char* filename) {
    struct stat st;
    stat(filename, &st);
    return st.st_size;   
}

int FirstSectorOfCluster(uint32_t cluster){ 
	int firstSector; 	
	firstSector = ((cluster-2)*BPB.SecPerClus + FirstDataSector); 
	return firstSector;
} 

uint32_t GetClusterOfDIR(uint32_t cluster, const char *DIRname) { 
	struct DIRStruct currentDIR;
	int offset; 
	int dirCluster;
	int sector;
	string higherDIR;

	while(cluster < EOC){
		sector = FirstSectorOfCluster(cluster);
		offset = sector*BPB.BytsPerSec;
		while(offset < (sector*BPB.BytsPerSec + BPB.BytsPerSec*BPB.SecPerClus)){
			currentDIR = ReadDIR(offset);
			if(strcmp(DIRname, "..") == 0){
				higherDIR = currentDIRstring;
				higherDIR.erase(higherDIR.rfind('/'));
				higherDIR.erase(higherDIR.rfind('/') + 1);
				if(higherDIR == "/"){
					return BPB.RootClus;
				}
			}
			if (currentDIR.Name[0] == EMPTY_ENTRY) 
				continue; 
			else if (currentDIR.Name[0] == LAST_ENTRY) 
				break; 
			else if (currentDIR.Name[0] == 0x05) 
				currentDIR.Name[0] = 0xE5; 
			if (currentDIR.Attrib != ATTR_LONG_NAME) {
				//cout << "Name: " << currentDIR.Name << endl;
				if(strcmp(currentDIR.Name, DIRname)==0){
					if(currentDIR.Attrib != ATTR_DIRECTORY){
						return 0;
					}
					dirCluster = (currentDIR.FstClusHI << 16 | currentDIR.FstClusLO);
					return dirCluster;
				}
			}
			offset+=32;
		} 
 		cluster = FAT(cluster);
	}

	return 0;
} 

uint32_t GetClusterOfFile(uint32_t cluster, const char *file) { 
	struct DIRStruct currentDIR;
	int offset; 
	int fileCluster;
	int sector;
	
	while(cluster < EOC){
		sector = FirstSectorOfCluster(cluster);
		offset = sector*BPB.BytsPerSec;
		while(offset < (sector*BPB.BytsPerSec + BPB.BytsPerSec*BPB.SecPerClus)){
			currentDIR = ReadDIR(offset);
			if (currentDIR.Name[0] == EMPTY_ENTRY) 
				continue; 
			else if (currentDIR.Name[0] == LAST_ENTRY) 
				break; 
			if (currentDIR.Attrib != ATTR_LONG_NAME) {
				//cout << "Name: " << currentDIR.Name << endl;
				if(strcmp(currentDIR.Name, file)==0){
					fileCluster = (currentDIR.FstClusHI << 16 | currentDIR.FstClusLO);
					return fileCluster;
				}
			}
			offset+=32;
		} 
 		cluster = FAT(cluster); 
	}

	return 0;
} 

uint32_t FAT(uint32_t cluster){ 
	uint32_t next; 
 	long offset; 
 	offset=BPB.RsvdSecCnt*BPB.BytsPerSec + cluster*4; 
 	next = ParseInteger<uint32_t>(image + offset); 
 	return next; 
} 

int toArgs(){
	const char *const space = " ";
	char *saveptr;
	int i = 0;

	//Remove newline
	command[strlen(command)-1] = '\0';
	//If command is blank
	if(strcmp(command, "") == 0)
		return -1;
	for(char *token = strtok_r(command, space, &saveptr); token != NULL; token = strtok_r(NULL, space, &saveptr)){
		args[i] = (char *) malloc(strlen(token) + 1);
		strcpy(args[i], token);
		
		
		//printf("args[%d] = %s\n", i, args[i]);
		i++;
	}
	return 0;
}

void clearArgs(){
	for(int i=0; args[i]!=NULL; i++) {
		bzero(args[i], strlen(args[i])+1);
		args[i] = NULL;
		free(args[i]);
	}
}


