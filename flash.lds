MEMORY 
{
	sdram	: ORIGIN = 0x400000,	LENGTH = 128K	/* SDRAM */
	flash	: ORIGIN = 0x2000000,	LENGTH = 128K	/* Flash */
}

SECTIONS 
{
	. = 0;

	.startup : 
	{ 
		*(.text)
		. = ALIGN(2);
	} > flash

	.text :                                                          
    {
 		*(.text*)                                                
		*(.rodata*)
		*(.eh_frame)
		. = ALIGN(4);
		_text_end = .;
	} > flash                                                    
	
	.data :     
	{
		_data_start = .;                                         
		*(.data*)                                              
		. = ALIGN(4);
		_data_end = .;                           
	} > sdram AT >flash
	
	.bss :                                                         
	{
		_bss_start = .;
		*(.bss*)                                                
		. = ALIGN(4);                                           
		_bss_end = . ;                                          
		_end = .;                                                       
		end = .;
	} > sdram                                                       	
}

