MEMORY 
{
	sdram	: ORIGIN = 0x400000,        	LENGTH = 128K
}

SECTIONS 
{
	. = 0;

	.startup : 
	{ 
		*(.text)
		. = ALIGN(2);
	} >sdram

	.text :                                                          
    {
 		*(.text*)                                                
		*(.rodata*)
		*(.eh_frame)
		. = ALIGN(4);
		_text_end = .;
	} > sdram                                                    
	
	.data :     
	{
		_data_start = .;                                         
		*(.data*)                                              
		. = ALIGN(4);
		_data_end = .;                           
	} > sdram
	
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

