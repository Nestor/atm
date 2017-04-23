/*--------------------------------------
    Ce n'est qui petite version de 
    test, en aucun cas cette addon 
    est a prendre au serieux ! 
    C'est juste une façon pour moi
          de m'entrainer.<3
--------------------------------------*/
include("shared.lua")

for i=10,100 do 
	surface.CreateFont("ATMFont"..i, {
	font = "Open Sans", 
	size = i, 
	weight = 2000
})
end 

local function formatNumber(n)
    if not n then return "" end
    if n >= 1e14 then return tostring(n) end
    n = tostring(n)
    local sep = sep or ","
    local dp = string.find(n, "%.") or #n+1
    for i=dp-4, 1, -3 do
        n = n:sub(1, i) .. sep .. n:sub(i+1)
    end
    return n
end

function ENT:Draw()
   self:DrawModel()

    local pos = self:GetPos()
    local ang = self:GetAngles()

    ang:RotateAroundAxis(ang:Up(), 180)
    ang:RotateAroundAxis(ang:Forward(), 105) 

    cam.Start3D2D(pos+ang:Up()*1.9+ang:Right()*22.1+ang:Forward()*15, ang, 0.17)

        local Service = "Erreur"

        if self:GetNWInt("service") == 0 then
            color_service = Color(0, 255, 0, 200)
            Service = "En service"
        elseif self:GetNWInt("service") == 1 then
            color_service = Color(247, 35, 12, 200)
            Service = "Hors-service"
        end

        draw.DrawText(Service, "ATMFont19", 0,-109, color_service, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end

net.Receive("OpenMenuATM",function()
	local Base = vgui.Create("DFrame")
    Base:SetSize( 300, 340 )
    Base:Center()
    Base:SetTitle("")
    Base:ShowCloseButton(true)
    Base:SetVisible(true)
    Base:MakePopup()
    Base.Paint = function(self,w,h)
        draw.RoundedBox(6, 0, 0, w, h, Color(44, 47, 52, 255))

        
        draw.RoundedBox(1, 0, 0, w, 45, Color(54, 57, 62, 255))
        draw.RoundedBox(1, 0, 46, w, 1, Color(0, 0, 0, 80))

        draw.RoundedBox(1, 0, h-47, w, 1, Color(0, 0, 0, 80))
        draw.RoundedBox(1, 0, h-45, w, 45, Color(54, 57, 62, 255))

        draw.DrawText("Vous avez "..formatNumber(LocalPlayer():GetNWInt("MoneyATM")).. "$ en banque.", "ATMFont25", w/2,h-35, color_white, TEXT_ALIGN_CENTER)
    end

	local Montant = vgui.Create( "DTextEntry", Base )
	Montant:SetPos( 24, 63 )
	Montant:SetSize( 250, 25 )
	Montant:SetText("Entrer un montant" )
	Montant:SetNumeric( true )
	Montant.OnGetFocus = function ()
		if Montant:GetText() == "Entrer un montant" then
			Montant:SetText("")
		end
	end

    local Depose = vgui.Create("DButton", Base)
    Depose:SetSize(250, 45)
    Depose:SetPos(24, 106)
    Depose:SetText("Déposer")
    Depose:SetFont("ATMFont25")
    Depose:SetTextColor(color_white)
    Depose.OnCursorEntered = function(self) 
        surface.PlaySound("UI/buttonrollover.wav") 
        self.hover = true 
        Depose:SetTextColor(Color(230, 92, 78))
    end
    Depose.OnCursorExited = function(self) 
        self.hover = false 
        Depose:SetTextColor(color_white)
    end
    Depose.Paint = function(self,w,h) 
        if self.hover then
            draw.RoundedBox(1, 0, 0, w, h, Color(36, 39, 44, 255))
        else
            draw.RoundedBox(2, 0, 0, w, h,  Color(54, 57, 62, 255))
        end
    end
	Depose.DoClick = function()
        if Montant:GetValue() == "" then
            chat.AddText(Color(230, 92, 78), "[ATM] ", color_white, "Vous devez entrez un montant.")
            LocalPlayer():EmitSound("buttons/button11.wav")
        elseif Montant:GetValue() == "Entrer un montant" then
            chat.AddText(Color(230, 92, 78), "[ATM] ", color_white, "Vous devez entrez un montant.")
            LocalPlayer():EmitSound("buttons/button11.wav")
        else
            net.Start("DeposeCashATM")
            net.WriteInt(Montant:GetValue(),32)
            net.SendToServer()

            Base:Remove()
        end
    end

    local Retirer = vgui.Create("DButton", Base)
    Retirer:SetSize(250, 45)
    Retirer:SetPos(24, 106+45+15)
    Retirer:SetText("Retirer")
    Retirer:SetFont("ATMFont25")
    Retirer:SetTextColor(color_white)
    Retirer.OnCursorEntered = function(self) 
        surface.PlaySound("UI/buttonrollover.wav") 
        self.hover = true 
        Retirer:SetTextColor(Color(230, 92, 78))
    end
    Retirer.OnCursorExited = function(self) 
        self.hover = false 
        Retirer:SetTextColor(color_white)
    end
    Retirer.Paint = function(self,w,h) 
        if self.hover then
            draw.RoundedBox(1, 0, 0, w, h, Color(36, 39, 44, 255))
        else
            draw.RoundedBox(2, 0, 0, w, h,  Color(54, 57, 62, 255))
        end
    end
	Retirer.DoClick = function()
        if Montant:GetValue() == "" then
            chat.AddText(Color(230, 92, 78), "[ATM] ", color_white, "Vous devez entrez un montant.")
            LocalPlayer():EmitSound("buttons/button11.wav")
        elseif Montant:GetValue() == "Entrer un montant" then
            chat.AddText(Color(230, 92, 78), "[ATM] ", color_white, "Vous devez entrez un montant.")
            LocalPlayer():EmitSound("buttons/button11.wav")
        else
    		net.Start("RetireCashATM")
    		net.WriteInt(Montant:GetValue(),32)
    		net.SendToServer()

            Base:Remove()
        end
    end

    local Transfert = vgui.Create("DButton", Base)
    Transfert:SetSize(250, 45)
    Transfert:SetPos(24, 166+45+15)
    Transfert:SetText("Faire un transfert")
    Transfert:SetFont("ATMFont25")
    Transfert:SetTextColor(color_white)
    Transfert.OnCursorEntered = function(self) 
        surface.PlaySound("UI/buttonrollover.wav") 
        self.hover = true 
        Transfert:SetTextColor(Color(230, 92, 78))
    end
    Transfert.OnCursorExited = function(self) 
        self.hover = false 
        Transfert:SetTextColor(color_white)
    end
    Transfert.Paint = function(self,w,h) 
        if self.hover then
            draw.RoundedBox(1, 0, 0, w, h, Color(36, 39, 44, 255))
        else
            draw.RoundedBox(2, 0, 0, w, h,  Color(54, 57, 62, 255))
        end
    end
    Transfert.DoClick = function()
        ATMTransfert()
        Base:Remove()
    end
end)

function ATMTransfert()
    local Base = vgui.Create("DFrame")
    Base:SetSize( 300, 255 )
    Base:Center()
    Base:SetTitle("")
    Base:ShowCloseButton(true)
    Base:SetVisible(true)
    Base:MakePopup()
    Base.Paint = function(self,w,h)
        draw.RoundedBox(6, 0, 0, w, h, Color(44, 47, 52, 255))

        
        draw.RoundedBox(1, 0, 0, w, 45, Color(54, 57, 62, 255))
        draw.RoundedBox(1, 0, 46, w, 1, Color(0, 0, 0, 80))

        draw.RoundedBox(1, 0, h-47, w, 1, Color(0, 0, 0, 80))
        draw.RoundedBox(1, 0, h-45, w, 45, Color(54, 57, 62, 255))

        draw.DrawText("Vous avez "..formatNumber(LocalPlayer():GetNWInt("MoneyATM")).. "$ en banque.", "ATMFont25", w/2,h-35, color_white, TEXT_ALIGN_CENTER)
    end

    local PlayerTransfert = vgui.Create( "DComboBox", Base )
    PlayerTransfert:SetPos( 24, 63 )
    PlayerTransfert:SetSize( 250, 25 )
    PlayerTransfert:SetValue( "Choissisez un joueur..." )
    for k,v in pairs(player.GetAll()) do
        PlayerTransfert:AddChoice( v:Nick() )
    end

    local MontantTransfert = vgui.Create( "DTextEntry", Base )
    MontantTransfert:SetPos( 24, 63+25+15 )
    MontantTransfert:SetSize( 250, 25 )
    MontantTransfert:SetText("Entrer un montant" )
    MontantTransfert:SetNumeric( true )
    MontantTransfert.OnGetFocus = function ()
        if MontantTransfert:GetText() == "Entrer un montant" then
            MontantTransfert:SetText("")
        end
    end

    local ValidateTransfert = vgui.Create("DButton", Base)
    ValidateTransfert:SetSize(250, 45)
    ValidateTransfert:SetPos(24, 100+25+15)
    ValidateTransfert:SetText("Valider")
    ValidateTransfert:SetFont("ATMFont25")
    ValidateTransfert:SetTextColor(color_white)
    ValidateTransfert.OnCursorEntered = function(self) 
        surface.PlaySound("UI/buttonrollover.wav") 
        self.hover = true 
        ValidateTransfert:SetTextColor(Color(230, 92, 78))
    end
    ValidateTransfert.OnCursorExited = function(self) 
        self.hover = false 
        ValidateTransfert:SetTextColor(color_white)
    end
    ValidateTransfert.Paint = function(self,w,h) 
        if self.hover then
            draw.RoundedBox(1, 0, 0, w, h, Color(36, 39, 44, 255))
        else
            draw.RoundedBox(2, 0, 0, w, h,  Color(54, 57, 62, 255))
        end
    end
    ValidateTransfert.DoClick = function()
        if MontantTransfert:GetValue() == "" then
            chat.AddText(Color(230, 92, 78), "[ATM] ", color_white, "Vous devez entrez un montant.")
            LocalPlayer():EmitSound("buttons/button11.wav")
        elseif MontantTransfert:GetValue() == "Entrer un montant" then
            chat.AddText(Color(230, 92, 78), "[ATM] ", color_white, "Vous devez entrez un montant.")
            LocalPlayer():EmitSound("buttons/button11.wav")
        elseif PlayerTransfert:GetValue() == "Choissisez un joueur..." then
            chat.AddText(Color(230, 92, 78), "[ATM] ", color_white, "Vous devez choisir un joueur.")
            LocalPlayer():EmitSound("buttons/button11.wav")
        else
            net.Start("TransfertCashATM")
            net.WriteInt(MontantTransfert:GetValue(),32)
            net.WriteString(PlayerTransfert:GetValue())
            net.SendToServer()

            Base:Remove()
        end
    end
end