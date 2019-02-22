/*
 * main.c
 *
 *  Created on: 9 Mar 2014
 *      Author: daniel
 */

#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

#define IH_MAGIC    0x27051956    /* Image Magic Number     */
#define IH_NMLEN    32            /* Image Name Length      */

typedef struct image_header {
	uint32_t    ih_magic;         /* Image Header Magic Number */
	uint32_t    ih_hcrc;          /* Image Header CRC Checksum */
	uint32_t    ih_time;          /* Image Creation Timestamp  */
	uint32_t    ih_size;          /* Image Data Size           */
	uint32_t    ih_load;          /* Data     Load  Address    */
	uint32_t    ih_ep;            /* Entry Point Address       */
	uint32_t    ih_dcrc;          /* Image Data CRC Checksum   */
	uint8_t     ih_os;            /* Operating System          */
	uint8_t     ih_arch;          /* CPU architecture          */
	uint8_t     ih_type;          /* Image Type                */
	uint8_t     ih_comp;          /* Compression Type          */
	uint8_t     ih_name[IH_NMLEN];    /* Image Name            */
} image_header_t;

#define FLASHLOADERSZ	(128 * 1024)

int main(int argc, char** argv) {
	printf("M68VZ328 flash loader (c)2014 Daniel Palmer\n");

	void* imagebase = (uint32_t*)(0x2000000 + FLASHLOADERSZ);
	printf("Kernel image should start @%p\n", imagebase);

	image_header_t* header = (image_header_t*) imagebase;

	if(header->ih_magic != IH_MAGIC)
		printf("Bad magic; wanted 0x%"PRIx32" got 0x%"PRIx32"\n", IH_MAGIC, header->ih_magic);
	else {
		printf("Loading kernel image into SDRAM @%"PRIx32"...\n", header->ih_ep);
		uint32_t* imagecurrent = (uint32_t*) (0x2000000 + FLASHLOADERSZ + 64);
		uint32_t* loadcurrent = (uint32_t*) header->ih_ep;
		uint32_t* imageend = imagecurrent + (header->ih_size/4);
		while(imagecurrent != imageend){
			*loadcurrent++ = *imagecurrent++;
		}
		printf("Jumping into kernel @%"PRIx32".. bye bye\n", header->ih_ep);
		asm volatile (
                     	"lea.l 0x400, %a0 \n\t"
                    	"jmp (%a0)\n\t");
	}
	while(1){}
}
