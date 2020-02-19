#include <stdio.h>
#include <stdlib.h>
#include <string.h>	
#ifndef FUNCTIONS
#define FUNCTIONS

	typedef struct LLVM{
	/* This struct contains:
	1) A string vector which will store on each line of the LLVM function file
  (where each string will be a line of the function).
	2) The number of lines
	3) The size of each line. */
		char **lines;
		int number_of_lines;
		int* size_of_lines;
	}LLVM;

    int** aloc_matriz(int, int);
  // matrix to store the "score" LCS (Longest Common Subsequence) algorithm

    LLVM format_input(FILE *);
  // takes as parameter the file to be formatted and returns a struct like "Function"
  // The return of an LLVM structure is to avoid having to recalculate the number of lines, and the size of each file.

    void lcs_fill_table(int**, LLVM, LLVM);
 // takes as parameter the file

    LLVM get_common_subsequence(int**, LLVM, LLVM);
  // get_common_subfile.linesuence gets the matrix from the LCD and returns the best alignment of the two codes

    void free_matriz(int**,int); 
  // function to deallocate memory
  // receive the matrix to be deallocated and number of line

    void free_LLVM(LLVM common_code);
  // function to deallocate memory
  // receive a struct LLVM
#endif