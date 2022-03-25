/*
	FileFunctions Plugin v0.1b (by RyDeR`)
*/

#if defined _INC_FileFunctions
	#endinput
#else
	#define _INC_FileFunctions
#endif

enum io_FileMode
{
	io_Read,
	io_Write,
	io_Append,
	io_ReadWrite,
	io_EmptyReadWrite,
	io_ReadAppend
};

enum seek_Origin
{
	seek_Start,
	seek_Current,
	seek_End
};

native File: fileOpen(const fileName[], io_FileMode: fileMode);
native File: fileReOpen(File: handle, const fileName[], io_FileMode: fileMode);
native fileClose(File: handle);
native fileRemove(const fileName[]);
native fileExists(const fileName[]);
native fileMove(const currentFilePath[], const newFilePath[]);
native fileRewind(File: handle);
native fileWrite(File: handle, const string[]);
native fileRead(File: handle, buffer[], const size = sizeof(buffer));
native filePutChar(File: handle, value);
native fileGetChar(File: handle);
native fileSeek(File: handle, position, seek_Origin: origin);
native fileLength(File: handle);