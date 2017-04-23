/*--------------------------------------
	Ce n'est qu'une petite version de 
	test, en aucun cas cette addon 
	est a prendre au serieux ! 
	C'est juste une façon pour moi
		  de m'entrainer.<3
--------------------------------------*/
AddCSLuaFile()

util.AddNetworkString("OpenMenuATM")
util.AddNetworkString("DeposeCashATM")
util.AddNetworkString("RetireCashATM")
util.AddNetworkString("TransfertCashATM")

/*--------------------------------------
		Check ATM Update
--------------------------------------*/

CurrentVersion = 1.0
Url_Check = "https://raw.githubusercontent.com/SlownLS/atm/master/check_update"

timer.Create("CheckATMUpdate",60,0,function()
	http.Fetch(Url_Check, function(body, size, headers, code)
		WebVersion = tonumber(body)
		if CurrentVersion != WebVersion then
			for _, ent in pairs(ents.FindByClass("atm")) do
				ent:SetNWInt("service",1)
			end
		else
			for _, ent in pairs(ents.FindByClass("atm")) do
				ent:SetNWInt("service",0)
			end
		end
	end)
end)

/*--------------------------------------
		Initialize SQL Table
--------------------------------------*/

function ATM_Table_Exist()
	if (!sql.TableExists("atm_slownls")) then
		query = "CREATE TABLE atm_slownls (steamid varchar(255), money varchar(255) )"
		result = sql.Query(query)
		if (sql.TableExists("atm_slownls")) then
			Msg("Bien joué ! La table atm_slownls à été créer ! \n")
		else
			Msg("Une erreur à été détecté pour la table atm_slownls ! \n")
			Msg( sql.LastError( result ) .. " \n" )
		end	
	end
end

function InitializeATM()
	ATM_Table_Exist()
end
hook.Add( "Initialize", "InitializeATM", InitializeATM )

/*--------------------------------------
		Check Player Exist SQL
--------------------------------------*/

function AddPlayerATMTable( SteamID, ply )
	steamID = SteamID
	sql.Query( "INSERT INTO atm_slownls (`steamid`, `money`)VALUES ('"..steamID.."', '0')" )
end

function CheckPlayerATMTableExist( ply )
	steamID = ply:GetNWString("SteamID")
	
	result = sql.Query("SELECT steamid, money FROM atm_slownls WHERE steamid = '"..steamID.."'")
	if (!result) then
		AddPlayerATMTable( steamID, ply )
	end
end

/*--------------------------------------
		Player PlayerInitialSpawn
--------------------------------------*/

function PlayerInitialSpawn( ply )
	timer.Create("InitialSpawnPlayerATM", 1, 1, function()
		SteamID = ply:SteamID()
		ply:SetNWString("steamid", SteamID)
		steamID = ply:GetNWString("steamid")

		CheckPlayerATMTableExist( ply )

		steamid = sql.QueryValue("SELECT steamid FROM atm_slownls WHERE steamid = '"..steamID.."'")
		money = sql.QueryValue("SELECT money FROM atm_slownls WHERE steamid = '"..steamID.."'")

		ply:SetNWString("steamid", steamid)
		ply:SetNWInt("MoneyATM", tonumber(money) )
	end)
end
hook.Add( "PlayerInitialSpawn", "PlayerInitialSpawn", PlayerInitialSpawn )

/*--------------------------------------
				Net
--------------------------------------*/

net.Receive( "DeposeCashATM", function(length, ply)
	local Montant = tonumber(net.ReadInt(32))

	if Montant > ply:getDarkRPVar("money") then
		ply:SendLua("local tab = {Color(230, 92, 78), [[ [ATM] ]], color_white, [[Vous n'avez pas assez d'argent.]] } chat.AddText(unpack(tab))")
		ply:EmitSound("buttons/button11.wav")
	else
		if Montant > 0 then
			ply:SetNWInt("MoneyATM", ply:GetNWInt("MoneyATM") + Montant)
			money = ply:GetNWInt("MoneyATM")
			steamid = ply:GetNWString("steamid")
			sql.Query("UPDATE atm_slownls SET money = "..money.." WHERE steamid = '"..steamid.."'")
			ply:addMoney(-Montant)

			DarkRP.log("[ATM] "..ply:Nick().." a ajouté "..Montant.."$ en banque.")
		end
	end
end)

net.Receive( "RetireCashATM", function(length, ply)
	local Montant = tonumber(net.ReadInt(32))

	if Montant > ply:GetNWInt("MoneyATM") then
		ply:SendLua("local tab = {Color(230, 92, 78), [[ [Bank] ]], color_white, [[Vous n'avez pas assez d'argent en banque.]] } chat.AddText(unpack(tab))")
		ply:EmitSound("buttons/button11.wav")
	else
		if Montant > 0 then
			ply:SetNWInt("MoneyATM", ply:GetNWInt("MoneyATM") - Montant)
			money = ply:GetNWInt("MoneyATM")
			steamid = ply:GetNWString("steamid")
			sql.Query("UPDATE atm_slownls SET money = "..money.." WHERE steamid = '"..steamid.."'")
			ply:addMoney(Montant)

			DarkRP.log("[ATM] "..ply:Nick().." a retirer "..Montant.."$ en banque.")
		end
	end
end)

net.Receive( "TransfertCashATM", function(length, ply)
	local Montant = tonumber(net.ReadInt(32))
	local PlayerTransfert = net.ReadString()

	if Montant > ply:GetNWInt("MoneyATM") then
		ply:SendLua("local tab = {Color(230, 92, 78), [[ [Bank] ]], color_white, [[Vous n'avez pas assez d'argent en banque.]] } chat.AddText(unpack(tab))")
		ply:EmitSound("buttons/button11.wav")
	else
		if Montant > 0 then
			ply:SetNWInt("MoneyATM", ply:GetNWInt("MoneyATM") - Montant)
			money = ply:GetNWInt("MoneyATM")
			steamid = ply:GetNWString("steamid")
			sql.Query("UPDATE atm_slownls SET money = "..money.." WHERE steamid = '"..steamid.."'")

			for k,v in pairs(player.GetAll()) do
				if v:Nick() == PlayerTransfert then
					v:SetNWInt("MoneyATM", v:GetNWInt("MoneyATM") + Montant)
					moneyTransfert = v:GetNWInt("MoneyATM")
					steamidTransfert = v:GetNWString("steamid")
					sql.Query("UPDATE atm_slownls SET money = "..moneyTransfert.." WHERE steamid = '"..steamidTransfert.."'")
				end
			end
			DarkRP.log("[ATM] "..ply:Nick().." a fait un transfert d'argent d'une somme de "..Montant.."$ à "..PlayerTransfert..".")
		end
	end
end)
