#include <amxmodx>
#include <amxmisc>
#include <cstrike>

new MONEY;

public plugin_init()
{
	register_plugin("round_money","0.7","SweatyBanana")
	
	MONEY = register_cvar("round_money","16000")
	
	/* Register LANG file */
	register_dictionary("rmlang.txt")
	
	register_logevent("new_round", 2, "1=Round_Start")
}
public new_round()
{
	new players[32], playerCount, i, player, pMoney;
	pMoney = get_pcvar_num(MONEY)
	
	get_players(players,playerCount);
	
	for(i=0;i<playerCount;i++)
	{
		player = players[i];
		if(cs_get_user_money(player) < pMoney)
		{
			cs_set_user_money(player, pMoney);
			client_print(player,print_chat,"%L",LANG_PLAYER,"MONEY_AMOUNT",pMoney)
		}
	} 
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1033\\ f0\\ fs16 \n\\ par }
*/
