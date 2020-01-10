#include <dirent.h>
#include <fnmatch.h>

DIR * opendir$INODE64( char * dirName );
DIR * opendir$INODE64( char * dirName )
{
return opendir( dirName );
}

struct dirent * readdir$INODE64( DIR * dir );
struct dirent * readdir$INODE64( DIR * dir )
{
return readdir( dir );
}