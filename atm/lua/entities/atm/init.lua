/*--------------------------------------
	Ce n'est qu'une petite version de 
	test, en aucun cas cette addon 
	est a prendre au serieux ! 
	C'est juste une façon pour moi
		  de m'entrainer.<3
--------------------------------------*/
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/codeandmodeling_slownls_atm/codeandmodeling_slownls_atm.mdl")	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self:SetNWInt("service", 0)
end

function ENT:SpawnFunction(ply, trace)
	local ent = ents.Create("atm")
	ent:SetPos(trace.HitPos + trace.HitNormal * 8)
	ent:Spawn()
	ent:Activate()
     
	return ent
end

function ENT:OnTakeDamage()
	return false 
end 

function ENT:AcceptInput( Name, Activator, Caller )	
	if Name == "Use" and Caller:IsPlayer() then
		if self:GetNWInt("service") == 1 then
			DarkRP.notify(Caller,2,5, "Les ATM's sont en maintenance.")
		else
			net.Start("OpenMenuATM")
			net.Send(Caller)
		end
	end
end
