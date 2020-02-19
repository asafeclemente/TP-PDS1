#include "TP.h"

int** aloc_matrix (int m, int n)
{
	int **matrix;
	matrix = (int**) malloc(m * sizeof(int*));
	if (matrix == NULL) { printf("Not enough memory.\n"); exit(1); }

	for (int i=0; i<m; i++){
		matrix[i] = (int*) malloc(n * sizeof(int));
		if (matrix[i] == NULL) { printf("Not enough memory.\n"); exit(1); }
	}
	return matrix;
}
LLVM format_input(FILE* file)
{
	fseek(file, 0L, SEEK_SET);
	LLVM llvm; //definition of structure in "TP.h"

// first let's count how many lines the llvm code has to allocate the right number of pointers to llvm.lines
    char character=0; //helper to count the '\n'
    llvm.number_of_lines = 0; 
    while(character != EOF){
    	character = fgetc(file);
    	if (character == '\n'){ //calculates how many '/n' there are, ie how many lines
             llvm.number_of_lines++;
         }
    }
	llvm.lines = (char**) malloc(llvm.number_of_lines * sizeof(char*));	

	llvm.size_of_lines = calloc(llvm.number_of_lines, sizeof(int));
	
	int line = 0; //position in the vetor sizeLines	

//now let's count and allocate the size of each row
	fseek(file, 0L, SEEK_SET); //rewind file
	character=0;

	while(character != EOF){
		character = fgetc(file);
		if (character != '\n' && character != EOF){
			llvm.size_of_lines[line]++;
		}
		if (character == '\n'){
			llvm.size_of_lines[line]++;
			line++;
		} 
	}
	fseek(file, 0L, SEEK_SET);
	for (int i=0; i < llvm.number_of_lines; i++){ // alloc the size of each line and copy to llvm.lines the file line
		llvm.lines[i] = (char*) malloc((llvm.size_of_lines[i]+1) * sizeof(char));
		llvm.lines[i] = fgets (llvm.lines[i],llvm.size_of_lines[i]+1, file);
	}
	return llvm;
}

void lcs_fill_table(int** matrix, LLVM llvm_1, LLVM llvm_2)
{
	for (int i=0; i< (llvm_1.number_of_lines+1); i++){
		for (int j=0; j< (llvm_2.number_of_lines+1); j++){
			if (i==0 || j==0){
				matrix[i][j] = 0;
			}
			else if ((strcmp(llvm_1.lines[i-1], llvm_2.lines[j-1])) == 0){
				matrix[i][j] = (matrix[i-1][j-1]) + 1;
			}
			else matrix[i][j] = ((matrix[i-1][j])> (matrix[i][j-1]) ? (matrix[i-1][j]) : (matrix[i][j-1]));
		}
	}
}

char** get_common_subsequence(int** matrix, LLVM llvm_1, LLVM llvm_2)
{
	/*just to have a shorter index*/
	int i = llvm_1.number_of_lines;
	int j = llvm_2.number_of_lines;

	int index = matrix[i][j];  //index is the number of lines of common code
	char** common_code;
	common_code = (char**) malloc(index * sizeof(char*));

	while (i > 0 && j > 0 && index >= 0){ 
		if (strcmp(llvm_1.lines[i-1], llvm_2.lines[j-1]) == 0){ //in this case the lines are equal
			common_code[index-1] = (char*) malloc(strlen(llvm_1.lines[i-1]) + 1 * sizeof(char));
			strcpy(common_code[index-1], llvm_1.lines[i-1]);
			index--; 
			j--;
			i--;
		}
		else matrix[i-1][j] > matrix[i][j-1] ? 
			(i--) : (j--);
	}
	return common_code;
}
void free_matrix(int**matrix, int m)
{
	for (int i=0; i < m+1; i++){
		free (matrix[i]);
		matrix[i] = NULL;
	}
	free (matrix);
	matrix == NULL;
}

//A instruction identifier common between two code functions
int main (int argc, char* argv[])
{
	if (argc != 3){
		printf("ERROR: is required to run \"program.c file1.ll file2.ll\"\n");
		exit (1);
	}

	FILE* file1; FILE* file2;
	file1 = fopen (argv[1], "r"); //file to get the first code LLVM
	file2 = fopen (argv[2], "r"); //the second code LLVM

	if (file1 == NULL || file2 == NULL){
 		printf("File format error.\n"); 
 		exit(1);
	};

	LLVM llvm_1, llvm_2; //look definition of structure in "TP.h"
	llvm_1.lines = NULL, llvm_2.lines = NULL; //remember that funciton.lines is char**

	llvm_1 = format_input (file1); 
	llvm_2 = format_input (file2);
    /*Now llvm_1, llvm_2 has file lines, number of 
    lines and size of each of the file1, file2.*/

	if (llvm_1.lines == NULL || llvm_1.lines == NULL){
		printf("File format error.\n");
		exit (1);
	}

	int **matrix;
	matrix = aloc_matrix(llvm_1.number_of_lines+1, llvm_2.number_of_lines+1);

	lcs_fill_table (matrix, llvm_1, llvm_2);

	fclose (file1);
	fclose (file2);

	char** common_code; 
	common_code = get_common_subsequence(matrix, llvm_1, llvm_2);
	
	for (int i=0; i < matrix[llvm_1.number_of_lines][llvm_2.number_of_lines]; i++){
		printf("%s", common_code[i]);
	}

	free_matrix(matrix, llvm_1.number_of_lines);

	//free_matrix

	return 0;
}