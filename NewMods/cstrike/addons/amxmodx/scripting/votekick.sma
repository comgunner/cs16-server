#include <amxmodx>
#include <amxmisc>
#define Keyschooseplayer (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)|(1<<9)
#define Keysyousure (1<<0)|(1<<1) // Keys: 12
#define Keysallvote (1<<0)|(1<<1)|(1<<3)|(1<<5) // Keys: 1246

#define VaultKey "VoteKick_%s"
#define VaultKeyTime "VoteKickTime_%s"

new MenuPoschooseplayer
new MenuPlayerschooseplayer[32]

new votes[2]
new bool:canvote
new votekicking[33]
new votekickids[2][32]
new votekickreason[28]
new voteendid
new cvaravk
new cvarab

public plugin_init() {
	register_plugin("/VoteKick","1.3","NL)Ramon(NL")
	register_clcmd("say /votekick","Showchooseplayer")
	register_menucmd(register_menuid("allvote"), Keysallvote, "Pressedallvote")
	register_menucmd(register_menuid("yousure"), Keysyousure, "Pressedyousure")
	register_menucmd(register_menuid("chooseplayer"), Keyschooseplayer, "Pressedchooseplayer")
	register_concmd("amx_blockvotekick","blockvotekick", ADMIN_BAN,"")
	register_concmd("amx_allowvotekick","allowvotekick", ADMIN_BAN,"")
	register_concmd("amx_blockvotekickid","blockvotekickid", ADMIN_BAN,"SteamID")
	register_concmd("amx_allowvotekickid","allowvotekickid", ADMIN_BAN,"SteamID")
	register_concmd("amx_cancelvotekick","cancelvote", ADMIN_BAN,"SteamID")
	cvaravk = register_cvar("amx_adminvotekick","0")
	cvarab = register_cvar("amx_votekickamxmbans","0")
	register_concmd("vote_kick_reason","reasonenter")
}

public cancelvote(id,level,cid) {
	if (!cmd_access(id,level,cid,1)) return PLUGIN_HANDLED
	if(voteendid) {
		remove_task(voteendid)
		client_print(id,print_console,"Votekick cancelado.")
		client_print(0,print_chat,"Votekick cancelado por el admin.")
	}
	else
	{
		client_print(id,print_console,"No hay ningun votekick en curso.")
	}
	return PLUGIN_CONTINUE
}

public reasonenter(id) {
	if(!votekicking[id]) return PLUGIN_HANDLED
	read_args(votekickreason,27)
	remove_quotes(votekickreason)
	if(!votekickreason[4]) {
		client_print(id,print_chat,"Razon muy corta, por favor intentelo nuevamente.")
		client_cmd(id,"messagemode vote_kick_reason")
		set_hudmessage(255, 0, 0, 0.0, 0.1, 0, 6.0, 12.0)
		show_hudmessage(id, "Por favor, escriba una razon valida y pulse enter.")	
		return PLUGIN_HANDLED
	}
	if(votekickreason[23]) { // else it wont fit on menu :S
		client_print(id,print_chat,"Razon muy larga(maximo 23 caracteres). Intentelo denuevo.")
		client_cmd(id,"messagemode vote_kick_reason")
		set_hudmessage(255, 0, 0, 0.0, 0.1, 0, 6.0, 12.0)
		show_hudmessage(id, "Por favor, escriba una razon valida y pulse enter.")	
		
		return PLUGIN_HANDLED
	}
	startvotekick(id)
	return PLUGIN_HANDLED
}

public get_vaultkey(key[41],id) {
	new Authid[32]
	get_user_authid(id,Authid,31)
	format(key,40,VaultKey,Authid)		
}

public get_vaultkeytime(key[41],id) {
	new Authid[32]
	get_user_authid(id,Authid,31)
	format(key,40,VaultKeyTime,Authid)		
}

public blockvotekickid(id,level,cid) {
	if (!cmd_access(id,level,cid,1)) return PLUGIN_HANDLED
	new arg[32]
	read_argv(1, arg, 31)
	if(!arg[8]) {
		client_print(id,print_console,"SteamID no valido.")
		return PLUGIN_HANDLED
	}
	new key[41]
	new blocktime
	new arg2[32]
	read_argv(2, arg2, 31)
	if(str_to_num(arg2) <= 0) {
		arg2 = "PERMANENT"
		format(key,40,VaultKey,arg)
		set_vaultdata(key,"1")
	}
	else {
		
		blocktime = str_to_num(arg2)
		suspendvotekick(arg,(blocktime * 60),1)
		format(key,40,VaultKey,arg)
		remove_vaultdata(key)
	}
	new message[200]
	new nowtime[32]
	new authid[32]
	new name[32]
	get_user_name(id,name,31)
	get_user_authid(id,authid,31)
	get_time("%x %X",nowtime,31)
	write_file("addons/amxmodx/logs/votekick.log","")
	format(message,199,"%s: %s %s Bloquear el votekick de %s por %s minutos",nowtime,name,authid,arg,arg2)
	write_file("addons/amxmodx/logs/votekick.log",message)
	client_print(id,print_chat,"Jugador con el ID: %s votekick bloqueado correctamente por %s minutos",arg,arg2)
	return PLUGIN_HANDLED
}

public blockvotekick(id,level,cid) {
	if (!cmd_access(id,level,cid,1)) return PLUGIN_HANDLED
	new arg[32]
	read_argv(1, arg, 31)
	new player = cmd_target(id, arg, 11)
	if(is_user_connected(player)) {
		new key[41]
		new blocktime
		new arg2[32]
		read_argv(2, arg2, 31)
		new authid2[32]
		get_user_authid(player,authid2,31)
		if(str_to_num(arg2) <= 0) {
			arg2 = "PERMANENT"
			format(key,40,VaultKey,authid2)
			set_vaultdata(key,"1")
			client_print(player,print_chat,"Su votekick ha sido bloqueado permanentemente por el admin.")
		}
		else {
			blocktime = str_to_num(arg2)
			suspendvotekick(authid2,(blocktime * 60),1)
			format(key,40,VaultKey,authid2)
			remove_vaultdata(key)
			client_print(player,print_chat,"Su votekick ha sido bloquado por el admin.")
		}
		new message[200]
		new nowtime[32]
		new authid[32]
		new name[32]
		new name2[32]
		get_user_name(id,name,31)
		get_user_authid(id,authid,31)
		get_user_name(player,name2,31)
		get_user_authid(player,authid2,31)
		get_time("%x %X",nowtime,31)
		write_file("addons/amxmodx/logs/votekick.log","")
		format(message,199,"%s: %s %s Bloquear el votekick de %s %s por %s minutos",nowtime,name,authid,name2,authid2,arg2)
		write_file("addons/amxmodx/logs/votekick.log",message)
		client_print(id,print_chat,"Jugador %s's votekick bloqueado correctamente.",name2)
	}
	return PLUGIN_HANDLED
}

public allowvotekickid(id,level,cid) {
	if (!cmd_access(id,level,cid,1)) return PLUGIN_HANDLED
	new arg[32]
	read_argv(1, arg, 31)
	if(!arg[8]) {
		client_print(id,print_console,"SteamID no valido.")
		return PLUGIN_HANDLED
	}
	new key[41]
	format(key,40,VaultKey,arg)
	new message[200]
	new nowtime[32]
	new authid[32]
	new name[32]
	get_user_name(id,name,31)
	get_user_authid(id,authid,31)
	get_time("%x %X",nowtime,31)
	write_file("addons/amxmodx/logs/votekick.log","")
	format(message,199,"%s: %s %s restaurando el votekick de %s",nowtime,name,authid,arg)
	write_file("addons/amxmodx/logs/votekick.log",message)
	remove_vaultdata(key)
	suspendvotekick(arg,0,1)
	client_print(id,print_chat,"Jugador con el ID: %s votekick desbloqueado.",arg)
	return PLUGIN_HANDLED
}

public allowvotekick(id,level,cid) {
	if (!cmd_access(id,level,cid,1)) return PLUGIN_HANDLED
	new arg[32]
	read_argv(1, arg, 31)
	new player = cmd_target(id, arg, 11)
	if(is_user_connected(player)) {
		new key[41]
		get_vaultkey(key,player)
		new message[200]
		new nowtime[32]
		new authid[32]
		new name[32]
		new name2[32]
		new authid2[32]
		get_user_name(id,name,31)
		get_user_authid(id,authid,31)
		get_user_name(player,name2,31)
		get_user_authid(player,authid2,31)
		get_time("%x %X",nowtime,31)
		write_file("addons/amxmodx/logs/votekick.log","")
		format(message,199,"%s: %s %s Restored votekick rights of %s %s",nowtime,name,authid,name2,authid2)
		write_file("addons/amxmodx/logs/votekick.log",message)
		remove_vaultdata(key)
		suspendvotekick(authid2,0,1)
		client_print(id,print_chat,"Jugador %s's votekick desbloqueado",name2)
		client_print(player,print_chat,"Ahora ya puedes iniciar un votekick.",name)
	}
	return PLUGIN_HANDLED
}

public Showchooseplayer(id) {
	new authid[32]
	get_user_authid(id,authid,31)
	if(equal(authid,"STEAM_ID_PENDING")) {
		client_print(id,print_chat,"No puedes iniciar un votekick, resien te conectas.")
		return PLUGIN_HANDLED
	}
	new key[41]
	if(get_playersnum() < 3) {
		client_print(id,print_chat,"Debe haber por lo menos 3 jugadores para hacer un votekick.")
		return PLUGIN_HANDLED
	}
	get_vaultkey(key,id)
	new allowed = get_vaultdata(key)
	//new allowed = str_to_num(AuthidAndData)
	if(allowed) {
		client_print(id,print_chat,"No puedes iniciar un votekick porque el admin te ha bloqueado permanentemente, por abuso.")
		return PLUGIN_HANDLED
	}
	get_vaultkeytime(key,id)
	if(get_vaultdata(key) > get_systime()) {
		client_print(id,print_chat,"No puedes iniciar un votekick por un tiempo.")
		return PLUGIN_HANDLED
	}
	if(!canvote) {
		ShowMenuchooseplayer(id, MenuPoschooseplayer = 0)
	}
	else {
		client_print(id,print_chat,"Otra votacion esta en marcha o ya termino, espere...")
	}
	return PLUGIN_CONTINUE
}

public ShowMenuchooseplayer(id, position) {
	// Menu stuff //
	if (position < 0) { return 0; }
	
	new i, k
	new MenuBody[255]
	new CurrentKey = 0
	new Start = position * 7
	new Num
	new UserName[32]
	
	get_players(MenuPlayerschooseplayer, Num)
	if (Start >= Num) { Start = position = MenuPoschooseplayer = 0; }
	new Len = format(MenuBody, 255, "VoteKick %d/%d^n^n", position+1, (Num / 7 + ((Num % 7) ? 1 : 0 )) )
	new End = Start + 7
	new Keys = (1<<9)
	if (End > Num) { End = Num; }
	
	for(i=Start;i<End;i++) {
		k = MenuPlayerschooseplayer[i]
		get_user_name(k, UserName, 31)
		Keys |= (1<<CurrentKey++)
		Len += format(MenuBody[Len], (255-Len), "%i. %s^n", CurrentKey, UserName)
	}
	if (End != Num) {
		format(MenuBody[Len], (255-Len), "^n9. Siguiente^n%s", position ? "0. Atras" : "0. Salir")
		Keys |= (1<<8)
	}
	else {
		format(MenuBody[Len], (255-Len), "^n%s", position ? "0. Atras" : "0. Salir")
	}
	show_menu(id, Keys, MenuBody, -1, "chooseplayer")
	return 0
}

public Pressedchooseplayer(id, key) {
	switch (key) {
		case 8: ShowMenuchooseplayer(id, ++MenuPoschooseplayer) // More Option
			case 9: ShowMenuchooseplayer(id, --MenuPoschooseplayer) // Back Option
			default: {
			// Get User ID and Username
			Showyousure(id,MenuPlayerschooseplayer[MenuPoschooseplayer * 7 + key])
		}
	}
	return PLUGIN_HANDLED
}

public Showyousure(id,tokick) {
	if(canvote) {
		client_print(id,print_chat,"Otra votacion esta en marcha o ya termino, espere...")
		return PLUGIN_HANDLED
	}
	if(id == tokick) {
		server_cmd("kick #%d ^"No te votes a ti mismo!^"", get_user_userid(id))
		return PLUGIN_HANDLED
	}
	if(is_user_admin(tokick)) {
		client_print(id,print_chat,"No puedes votar a un admin!")
		new name[32]
		get_user_name(id,name,31)
		client_print(tokick,print_chat,"%s votekick bloqueado!")
		write_file("addons/amxmodx/logs/votekick.log","")
		new message[200]
		new authid[32]
		new name2[32]
		new authid2[32]
		new nowtime[32]
		get_time("%x %X",nowtime,31)
		get_user_authid(id,authid,31)
		get_user_name(tokick,name2,31)
		get_user_authid(tokick,authid2,31)
		format(message,199,"%s: %s %s queria iniciar un votekick contra un admin %s %s, votekick bloqueado!",nowtime,name,authid,name2,authid2)
		write_file("addons/amxmodx/logs/votekick.log",message)
		return PLUGIN_HANDLED
	}
	votekicking[id] = tokick
	new menu[256]
	new name[32]
	get_user_name(tokick,name,31)
	format(menu,255,"Esta seguro que desea iniciar un votekick contra:^n%s?^nSi hay pocos votos^nusted sera baneado por 10 minutos^nsino el otro jugador^n%s sera^nbaneado por 10 minutos^n^n1. Si ^n2. No^n",name,name)
	show_menu(id, Keysyousure, menu, 30, "yousure") // Display menu
	return PLUGIN_CONTINUE
}

public Pressedyousure(id, key) {
	if(canvote) {
		client_print(0,print_chat,"Una votacion acaba de iniciar, espere...")
		return PLUGIN_HANDLED
	}
	if(key == 0) {
		client_cmd(id,"messagemode vote_kick_reason")
		set_hudmessage(255, 0, 0, 0.0, 0.1, 0, 6.0, 12.0)
		show_hudmessage(id, "Por favor, ingrese una razon valida.")	
	}
	return PLUGIN_CONTINUE
}

public startvotekick(id) {
	if(canvote) {
		client_print(id,print_chat,"Una votacion acaba de iniciar, espere..."")
		return PLUGIN_HANDLED
	}
	new name[32]
	new authid[32]
	new name2[32]
	new authid2[32]
	get_user_name(id,name,31)
	get_user_authid(id,authid,31)
	get_user_name(votekicking[id],name2,31)
	get_user_authid(votekicking[id],authid2,31)
	server_print("-")
	if(get_pcvar_num(cvaravk)) {
		new i,maxpl,done
		maxpl = get_maxplayers()
		while (i<maxpl) {
			if(is_user_connected(i)) {
				if(is_user_admin(i)) {
					done=1
					client_print(i,print_chat,"%s Votekick %s, Este votekick ha sido bloqueado.",name,name2)
				}
			}
			++i
		}
		if(done) {
			client_print(id,print_chat,"El admin esta conectado, no se puede realizar un votekick.")
			return PLUGIN_CONTINUE
		}
	}
	new message[200]
	new nowtime[32]
	get_time("%x %X",nowtime,31)
	format(message,199,"%s: %s %s inicio una votacion contra %s %s Razon:",nowtime,name,authid,name2,authid2)
	write_file("addons/amxmodx/logs/votekick.log","")
	write_file("addons/amxmodx/logs/votekick.log",message)
	write_file("addons/amxmodx/logs/votekick.log",votekickreason)
	votekick(id)
	return PLUGIN_CONTINUE
}

public votekick(id) {
	get_user_authid(id,votekickids[0],31)
	get_user_authid(votekicking[id],votekickids[1],31)
	new menu[256]
	new name1[32],name2[32]
	get_user_name(id,name1,31)
	get_user_name(votekicking[id],name2,31)
	format(menu,255,"%s inicio una votacion^nQuieres kickear a %s?^nRazon:^n^n%s^n^n1. Si ^n2. No^n^n4. Si(anonimo)^n^n6. Ninguno.",name1,name2,votekickreason)
	show_menu(0, Keysallvote, menu, 30, "allvote") // Display menu
	voteendid = id
	set_task(30.0,"voteend",id)
	set_task(180.0,"allowvote")
	canvote = true
	client_print(0,print_chat,"%s inicio una votacion contra %s.",name1,name2)
	client_print(0,print_chat,"REASON: %s",votekickreason)
	votekicking[id] = 0
	suspendvotekick(votekickids[0],600,0)
}

public Pressedallvote(id, key) {
	switch (key) {
		case 0: { // 1
			++votes[0]
			new name[32]
			get_user_name(id,name,31)
			client_print(0,print_chat,"%s votaron si",name)
		}
		case 1: { // 2
			++votes[1]
			new name[32]
			get_user_name(id,name,31)
			client_print(0,print_chat,"%s votaron no",name)
		}
		case 3: { //4
			++votes[0]
		}
	}
}

public voteend(id) {
	voteendid = 0
	new Float:totalvotes = float(votes[0] + votes[1])
	new Float:percent = (votes[0] / totalvotes * 100.0)
	if(totalvotes <3.0) {
		client_print(0,print_chat,"Resultado: Hay menos de 3 jugadores, votekick cancelado.")
		return PLUGIN_HANDLED
	}
	if(percent <= 40) {
		client_print(0,print_chat,"Resultado: Hay pocos votos. El que inicio la votacion sera baneado por 10 minutos.")
		new authid[32]
		write_file("addons/amxmodx/logs/votekick.log","Votekick fallado, El que inicio la votacion sera kickeado.")
		new players[32], pnum, player
		get_players(players, pnum)
		
		for( new i=0; i<pnum; i++){
			player = players[i]
			get_user_authid(player,authid,31)
			if(equal(authid,votekickids[0])) {
				if(get_pcvar_num(cvarab)) {
					server_cmd("amx_ban ^"10^" ^"%s^" ^"Kickeado por votacion fallida, 10 minutos baneado^"",authid)
				}
				else {
					server_cmd("kick #%d ^"Kickeado por votacion fallida, 10 minutos baneado^"", get_user_userid(player))
					server_cmd("banid ^"10^" ^"%s^";wait;writeid", authid)
				}
				suspendvotekick(authid,86400,0)
				return PLUGIN_HANDLED
			}
		}
		server_cmd("banid ^"10^" ^"%s^";wait;writeid", votekickids[0])
		set_task(10.0,"checkifuserison",0,votekickids[0],31)
		set_task(30.0,"checkifuserison",0,votekickids[0],31)
		set_task(60.0,"checkifuserison",0,votekickids[0],31)
		checkifuserison(votekickids[1])
		suspendvotekick(votekickids[0],86400,0)
		
	}
	else if(percent >= 60) {
		client_print(0,print_chat,"Resultado: Hay muchos votos. Usuario baneado por 10 minutos.")
		new authid[32]
		write_file("addons/amxmodx/logs/votekick.log","Vote terminado, usuario kickeado.")
		new players[32], pnum, player
		get_players(players, pnum)
		
		for( new i=0; i<pnum; i++){
			player = players[i]
			get_user_authid(player,authid,31)
			if(equal(authid,votekickids[1])) {
				if(get_pcvar_num(cvarab)) {
					server_cmd("amx_ban ^"10^" ^"%s^" ^"Vote kick con muchos votos, usuario kickeado y baneado por 10 minutos^"",authid)
				}
				else {
					server_cmd("kick #%d ^"Vote kick con muchos votos, usuario kickeado y baneado por 10 minutos^"", get_user_userid(player))
					server_cmd("banid ^"10^" ^"%s^";wait;writeid", authid)
				}
				suspendvotekick(authid,86400,0)
				return PLUGIN_HANDLED
			}
		}
		server_cmd("banid ^"10^" ^"%s^";wait;writeid", votekickids[1])
		set_task(10.0,"checkifuserison",0,votekickids[1],31)
		set_task(30.0,"checkifuserison",0,votekickids[1],31)
		set_task(60.0,"checkifuserison",0,votekickids[1],31)
		checkifuserison(votekickids[1])
		suspendvotekick(votekickids[1],86400,0)
		
	}
	else {
		write_file("addons/amxmodx/logs/votekick.log","Vote fallido, no hay votos.")
		client_print(0,print_chat,"Resultado: El porcentaje de votos es entre 40 y 60, voto cancelado.")
	}
	return PLUGIN_CONTINUE
}

public checkifuserison(steamid[]) {
	new authid[32]
	new players[32], pnum, player
	get_players(players, pnum)
	for( new i=0; i<pnum; i++){
		player = players[i]
		get_user_authid(player,authid,31)
		if(equal(authid,votekickids[1])) {
			server_cmd("kick #%d ^"Fallo el votekick, no se podra volver a conectar^"", get_user_userid(player))
			return PLUGIN_CONTINUE
		}
	}
	return PLUGIN_CONTINUE
}

public suspendvotekick(authid[32],seconds,force) {
	new key[41]
	format(key,40,VaultKeyTime,authid)
	new data[20]
	get_vaultdata(key,data)
	if(!force && str_to_num(data) > get_systime() + seconds) return PLUGIN_CONTINUE
	num_to_str(get_systime() + seconds,data,19)
	set_vaultdata(key,data)
	return PLUGIN_CONTINUE
}

public allowvote() canvote = false
