/* 
*  AMX X Mod script. 
* 
* (c) Copyright 2003, ST4life 
* Remade by TaL
* This file is provided as is (no warranties). 
*/ 

#include <amxmodx> 

/* 
* TimeProjector displays the remaining time and the next map on the top right corner of the client 
* display as a hudmessage. 
* 
* History: 
* 
* v0.1: - first release 
*/ 


public show_timer(){ 
    new nextmap[32] 
    get_cvar_string("amx_nextmap",nextmap,31) 
    new timeleft = get_timeleft() 
    set_hudmessage(255,255,255,0.75,0.05,0, 1.0, 1.0, 0.1, 0.2, 13) 
    show_hudmessage(0,"Tiempo restante: %d:%02d^nProximo Mapa: %s",timeleft / 60, timeleft % 60,nextmap) 
    return PLUGIN_CONTINUE 
} 

public plugin_init() 
{ 
    register_plugin("TimeProjector","0.1","ST4life") 
    set_task(1.0, "show_timer",0,"",0,"b") 
    return PLUGIN_CONTINUE 
} 