#include <stdlib.h>
#include <stdio.h>

char* text1 = "This is a string.";
char* text2 = "Yet another thing.";

int count = 0;

int list1[80];
int list2[80];

void printlist(const int* lst){
  printf("ASCII codes and corresponding characters.\n");
  while(*lst != 0){
    printf("0x%03X '%c' ", *lst, (char)*lst);
    lst++;
  }
  printf("\n");
}

void endian_proof(const char* c){
  printf("\nEndian experiment: 0x%02x,0x%02x,0x%02x,0x%02x\n", 
         (int)*c,(int)*(c+1), (int)*(c+2), (int)*(c+3));
  
}

void copycodes(char *textpointer, int *listpointer, int *countpointer) {
	
	char *address = textpointer;	//adressen till första tecknet	
	char temp = *address;		//första tecknet
	while(temp){
		*listpointer = temp;	//lägg till tecknet i listan
		
		listpointer++;			//flytta ett steg i listan
		address++;			//flytta ett steg i texten
		*countpointer = 1 + *countpointer;		//öka counter med 1
		temp = *address;		//hämta nästa tecken från nästa adress
	}
}

void work() {
	int *countpointer = &count;
	char *textpointer = text1;
	copycodes(textpointer, list1, countpointer);

	textpointer = text2;
	copycodes(textpointer, list2, countpointer);
}





int main(void){
  work();

  printf("\nlist1: ");
  printlist(list1);
  printf("\nlist2: ");
  printlist(list2);
  printf("\nCount = %d\n", count);

  endian_proof((char*) &count);
}