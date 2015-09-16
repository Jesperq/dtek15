/*
 sieves.c
 By Jesper Qvarfordt & Rickard Larsson.
 Last modified: 2015-09-16
 This file is in the public domain.
*/


#include <stdio.h>
#include <stdlib.h>

#define COLUMNS 6

//prints number n
void print_number(int n){
	static int counter = 0;	
	
	printf("%10d ", n);
	
	counter++;
	if(counter % COLUMNS == 0){
		printf("\n");
	}
}

void print_sieves(int n){
	int numbers[n-2]; //n-1 d� vi b�rjar p� 2 och inte 1
	int i;

	//s�tt alla v�rden till true
	for(i = 0; i < n-2; i++)
		numbers[i] = 1;
	
	//s�tt alla v�rden till r�tt 1 eller 0 beroende p� om de �r primtal eller ej
	int loop = 1;
	int firstNumber = 2;
	int firstIndex = 0;
	while(loop == 1){
		

		//"hoppa" igenom lista med r�tt stegl�ngd och stryk varje nummer man stannar p�
		loop = 0;
		for(i = firstIndex+firstNumber; i < n-2; i+=firstNumber){
			if(numbers[i] == 1){
				numbers[i] = 0;
				loop = 1;
			}
		} 

		//hitta den f�rsta siffran som ej �r "struken" s� att vi vet vart vi ska b�rja n�sta iteration
		firstIndex++;
		for(i = firstIndex; i < n-2; i++){
			if(numbers[i] != 0){
				firstNumber = i+2;
				firstIndex = i;
				break;
			}				
		}
	}
		

	//skriv ut primtal
	for(i = 0; i < n-2; i++){
		if(numbers[i] == 1){
			print_number(i+2);
		}
	}
	
		
}

// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char *argv[]){
	if(argc == 2)
		print_sieves(atoi(argv[1]));
	else
		printf("Please state an interger number.\n");
	return 0;
}
