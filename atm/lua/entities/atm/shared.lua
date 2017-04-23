/*--------------------------------------
	Ce n'est qu'une petite version de 
	test, en aucun cas cette addon 
	est a prendre au serieux ! 
	C'est juste une façon pour moi
		  de m'entrainer.<3
--------------------------------------*/
ENT.Base = "base_ai" 
ENT.Type = "ai"
ENT.PrintName = "ATM"
ENT.Category 		= "♦ SlownLS | ATM ♦";
ENT.Author			= "SlownLS";
ENT.Instructions = "Appuyer sur E (Touche 'USE')" 
ENT.Spawnable = true 
ENT.AdminSpawnable = true 
ENT.AutomaticFrameAdvance = true 

function ENT:SetAutomaticFrameAdvance(bUsingAnim) 
	self.AutomaticFrameAdvance = bUsingAnim 
end
