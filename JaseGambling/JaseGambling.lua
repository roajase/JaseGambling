JaseGambling1 = LibStub("AceAddon-3.0"):NewAddon("JaseGambling1")
local JaseGambling1	= LibStub("AceAddon-3.0"):GetAddon("JaseGambling1")
local AcceptOnes = "false";
local AcceptRolls = "false";
local GameMode = 100; 
local totalrolls = 0
local tierolls = 0;
local theMax

local badbeat_percentage = "0.25";
local badbeat_success = 0;
local badbeat_close = 0;
local badbeat_second = "";
local badbeat_third = "";
local totaljackpot = "";
local totaljackpotgold = "";

local lowname = ""
local highname = ""
local low = 0
local high = 0
local tie = 0
local highbreak = 0;
local lowbreak = 0;
local tiehigh = 0;
local tielow = 0;
local whispermethod = false;
local totalentries = 0;
local highplayername = "";
local lowplayername = "";
local lastroll = "";
local rollCmd = SLASH_RANDOM1:upper();
local debugLevel = 0;
local virag_debug = false
local chatmethods = {
	"RAID",
	"PARTY",
	"GUILD"
}
local chatmethod = chatmethods[1];

function JaseGambling1:ConstructMiniMapIcon() 
	self.minimap = { }
	self.minimap.icon_data = LibStub("LibDataBroker-1.1"):NewDataObject("JaseGamblingIcon", {
		type = "data source",
		text = "JaseGambling",
		icon = "Interface\\AddOns\\JaseGambling\\media\\icon",
		OnClick = Minimap_Toggle,

		OnTooltipShow = function(tooltip)
			tooltip:AddLine("Jase's Gambling",1,1,1)
			tooltip:Show()
		end,
	})

	self.minimap.icon = LibStub("LibDBIcon-1.0")
	self.minimap.icon:Register("JaseGamblingIcon", self.minimap.icon_data, self.db.global.minimap)
end
-- GUI
local Blank = "Interface\\AddOns\\JaseGambling\\Media\\Blank.tga"
local Font = "Interface\\AddOns\\JaseGambling\\Media\\PTSans.ttf"
local FontColor = {220/255, 220/255, 220/255}
local FontColor2 = {69/255, 188/255, 218/255}
local FontColor3 = {187/255, 217/255, 69/255}

local Backdrop = {
	bgFile = Blank,
	edgeFile = Blank,
	tile = false, tileSize = 0, edgeSize = 2,
	insets = {left = 0, right = 0, top = 0, bottom = 0},
}

local SetTemplate = function(self)
	self:SetBackdrop(Backdrop)
	self:SetBackdropColor(0.7, 0.7, 0.7)
end

local SetTemplateDark = function(self)
	self:SetBackdrop(Backdrop)
	self:SetBackdropColor(0.3, 0.3, 0.3)
end

local GUI = CreateFrame("Frame", "JaseGambling_Frame", UIParent)
GUI:SetSize(140, 196) 
GUI:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
SetTemplate(GUI)
GUI:SetMovable(true)
GUI:EnableMouse(true)
GUI:SetUserPlaced(true)
GUI:RegisterForDrag("LeftButton")
GUI:SetScript("OnDragStart", GUI.StartMoving)
GUI:SetScript("OnDragStop", GUI.StopMovingOrSizing)

CHAT = CreateFrame("Frame", nil, GUI)
CHAT:SetSize(GUI:GetSize(), 30)
CHAT:SetPoint("TOPLEFT", GUI, 0, 0)
SetTemplateDark(CHAT)
CHAT:SetScript("OnEnter", ButtonOnEnter)
CHAT:HookScript("OnEnter", function(self)
	GameTooltip:SetText(chatmethod)
	GameTooltip:AddLine("Change Chat Method", 1, 1, 1, true)
	GameTooltip:Show()
end)
CHAT:SetScript("OnLeave", ButtonOnLeave)
CHAT:SetScript("OnMouseUp", function(self)
JaseGambling_OnClickCHAT()
end)

JaseGambling_CHAT_Button = CHAT:CreateFontString(nil, "OVERLAY")
JaseGambling_CHAT_Button:SetPoint("LEFT", CHAT, 15, -1)
JaseGambling_CHAT_Button:SetFont(Font, 16)
JaseGambling_CHAT_Button:SetJustifyH("CENTER")
JaseGambling_CHAT_Button:SetTextColor(unpack(FontColor2))
JaseGambling_CHAT_Button:SetText(chatmethod)
JaseGambling_CHAT_Button:SetShadowOffset(1.25, -1.25)
JaseGambling_CHAT_Button:SetShadowColor(0, 0, 0)

EnterButton = CreateFrame("Frame", "JaseGambleJoinButton", CHAT)
EnterButton:SetSize(GUI:GetSize(), 25)
EnterButton:SetPoint("TOPLEFT", CHAT, 0, -32)
SetTemplateDark(EnterButton)
EnterButton:SetScript("OnEnter", ButtonOnEnter)
EnterButton:SetScript("OnLeave", ButtonOnLeave)
EnterButton:SetScript("OnMouseUp", function(self)
	JaseGambling_OnClickRoll1()
end)

EnterButton.Disable = function(self)
	self.Label:SetTextColor(0.3, 0.3, 0.3)
	self:EnableMouse(false)
end

EnterButton.Enable = function(self)
	self.Label:SetTextColor(unpack(FontColor))
	self:EnableMouse(true)
end

EnterButton.Label = EnterButton:CreateFontString(nil, "OVERLAY")
EnterButton.Label:SetPoint("CENTER", EnterButton, 0, 0)
EnterButton.Label:SetFont(Font, 14)
EnterButton.Label:SetJustifyH("CENTER")
EnterButton.Label:SetTextColor(unpack(FontColor))
EnterButton.Label:SetText("Join Game")
EnterButton.Label:SetShadowOffset(1.25, -1.25)
EnterButton.Label:SetShadowColor(0, 0, 0)


PassButton = CreateFrame("Frame", "JaseGamblePassButton", EnterButton)
PassButton:SetSize(GUI:GetSize(), 25)
PassButton:SetPoint("TOPLEFT", EnterButton, 0, -24)
SetTemplateDark(PassButton)
PassButton:SetScript("OnEnter", ButtonOnEnter)
PassButton:SetScript("OnLeave", ButtonOnLeave)
PassButton:SetScript("OnMouseUp", function(self)
	JaseGambling_OnClickRoll1()
end)

PassButton.Disable = function(self)
	self.Label:SetTextColor(0.3, 0.3, 0.3)
	self:EnableMouse(false)
end

PassButton.Enable = function(self)
	self.Label:SetTextColor(unpack(FontColor))
	self:EnableMouse(true)
end

PassButton.Label = PassButton:CreateFontString(nil, "OVERLAY")
PassButton.Label:SetPoint("CENTER", PassButton, 0, 0)
PassButton.Label:SetFont(Font, 14)
PassButton.Label:SetJustifyH("CENTER")
PassButton.Label:SetTextColor(unpack(FontColor))
PassButton.Label:SetText("Leave Game")
PassButton.Label:SetShadowOffset(1.25, -1.25)
PassButton.Label:SetShadowColor(0, 0, 0)

local EditBoxDown = function(self)
	self:SetAutoFocus(true)
	self:SetText("") 
end

local EditBoxOnEditFocusLost = function(self)
	self:SetAutoFocus(false)
end

local EditBoxOnEscapePressed = function(self)
	self:SetAutoFocus(false)
	self:ClearFocus()
end

local EditBoxOnEnterPressed = function(self)
	self:SetAutoFocus(false)
	self:ClearFocus()

	local Value = self:GetText()

	if (Value == "" or Value == " ") then
		self:SetText(CurrentRollValue)

		return
	end
end

local EditBoxOnEnterPressed2 = function(self)
	self:SetAutoFocus(false)
	self:ClearFocus()

	local Value = self:GetText()

	if (Value == "" or Value == " ") then
		self:SetText(CurrentRollValue)

		return
	end
end


local EditBox = CreateFrame("Frame", nil, PassButton)
EditBox:SetSize(GUI:GetSize(), 25)
EditBox:SetPoint("TOPLEFT", PassButton, 0, -24)
SetTemplateDark(EditBox)
EditBox:EnableMouse(true)

JaseGambling_EditBox = CreateFrame("EditBox", nil, EditBox)
JaseGambling_EditBox:SetPoint("CENTER", EditBox, 0, -2)
JaseGambling_EditBox:SetPoint("BOTTOMRIGHT", EditBox, 0, 0)
JaseGambling_EditBox:SetFont(Font, 16)
JaseGambling_EditBox:SetText("100")
JaseGambling_EditBox:SetTextColor(unpack(FontColor3))
JaseGambling_EditBox:SetShadowColor(0, 0, 0)
JaseGambling_EditBox:SetShadowOffset(1.25, -1.25)
JaseGambling_EditBox:SetMaxLetters(6)
JaseGambling_EditBox:SetAutoFocus(false)
JaseGambling_EditBox:SetNumeric(true)
JaseGambling_EditBox:EnableKeyboard(true)
JaseGambling_EditBox:EnableMouse(true)
JaseGambling_EditBox:SetScript("OnMouseDown", EditBoxOnMouseDown)
JaseGambling_EditBox:SetScript("OnEscapePressed", EditBoxOnEscapePressed)
JaseGambling_EditBox:SetScript("OnEnterPressed", EditBoxOnEnterPressed)
JaseGambling_EditBox:SetScript("OnEditFocusLost", EditBoxOnEditFocusLost)


AcceptRolls = CreateFrame("Frame", nil, EditBox)
AcceptRolls:SetSize(GUI:GetSize(), 25)
AcceptRolls:SetPoint("TOPLEFT", EditBox, 0, -24)
SetTemplateDark(AcceptRolls)
AcceptRolls:SetScript("OnEnter", ButtonOnEnter)
AcceptRolls:HookScript("OnEnter", function(self)
end)

AcceptRolls:SetScript("OnLeave", ButtonOnLeave)
AcceptRolls:SetScript("OnMouseUp", function(self)
	JaseGambling_OnClickACCEPTONES()
	JaseGambling["GameMode"] = false; 
end)

AcceptRolls.Disable = function(self)
	self.Label:SetTextColor(0.3, 0.3, 0.3)
	self:EnableMouse(false)
end

AcceptRolls.Enable = function(self)
	self.Label:SetTextColor(unpack(FontColor))
	self:EnableMouse(true)
end

AcceptRolls.Label = AcceptRolls:CreateFontString(nil, "OVERLAY")
AcceptRolls.Label:SetPoint("CENTER", AcceptRolls, 0, 0)
AcceptRolls.Label:SetFont(Font, 14)
AcceptRolls.Label:SetJustifyH("CENTER")
AcceptRolls.Label:SetTextColor(unpack(FontColor))
AcceptRolls.Label:SetText("New Game")
AcceptRolls.Label:SetShadowOffset(1.25, -1.25)
AcceptRolls.Label:SetShadowColor(0, 0, 0)

LastCall = CreateFrame("Frame", nil, AcceptRolls)
LastCall:SetSize(GUI:GetSize(), 25)
LastCall:SetPoint("TOPLEFT", AcceptRolls, 0, -24)
SetTemplateDark(LastCall)
LastCall:SetScript("OnEnter", ButtonOnEnter)
LastCall:HookScript("OnEnter", function(self)

end)
LastCall:SetScript("OnLeave", ButtonOnLeave)
LastCall:SetScript("OnMouseUp", function(self)
	JaseGambling_OnClickLASTCALL();
end)

LastCall.Disable = function(self)
	self.Label:SetTextColor(0.3, 0.3, 0.3)
	self:EnableMouse(false)
end

LastCall.Enable = function(self)
	self.Label:SetTextColor(unpack(FontColor))
	self:EnableMouse(true)
end

LastCall.Label = LastCall:CreateFontString(nil, "OVERLAY")
LastCall.Label:SetPoint("CENTER", LastCall, 0, 0)
LastCall.Label:SetFont(Font, 14)
LastCall.Label:SetJustifyH("CENTER")
LastCall.Label:SetTextColor(unpack(FontColor))
LastCall.Label:SetText("Last Call")
LastCall.Label:SetShadowOffset(1.25, -1.25)
LastCall.Label:SetShadowColor(0, 0, 0)

RollGame = CreateFrame("Frame", nil, LastCall)
RollGame:SetSize(GUI:GetSize(), 25)
RollGame:SetPoint("TOPLEFT", LastCall, 0, -24)
SetTemplateDark(RollGame)
RollGame:SetScript("OnEnter", ButtonOnEnter)
RollGame:HookScript("OnEnter", function(self)

end)
RollGame:SetScript("OnLeave", ButtonOnLeave)
RollGame:SetScript("OnMouseUp", function(self)
	JaseGambling_OnClickROLL()
end)

RollGame.Disable = function(self)
	self.Label:SetTextColor(0.3, 0.3, 0.3)
	self:EnableMouse(false)
end

RollGame.Enable = function(self)
	self.Label:SetTextColor(unpack(FontColor))
	self:EnableMouse(true)
end

RollGame.Label = RollGame:CreateFontString(nil, "OVERLAY")
RollGame.Label:SetPoint("CENTER", RollGame, 0, 0)
RollGame.Label:SetFont(Font, 14)
RollGame.Label:SetJustifyH("CENTER")
RollGame.Label:SetTextColor(unpack(FontColor))
RollGame.Label:SetText("Start Rolling")
RollGame.Label:SetShadowOffset(1.25, -1.25)
RollGame.Label:SetShadowColor(0, 0, 0)

RollGame:Disable()
LastCall:Disable()
EnterButton:Enable()
PassButton:Enable()

local EditBoxOnEditFocusLost = function(self)
	self:SetAutoFocus(false)
end

local EditBoxOnEscapePressed = function(self)
	self:SetText("")

	self:SetAutoFocus(false)
	self:ClearFocus()

	self:SetText("|cffB0B0B0Chat...|r")
end

local EditBoxOnEnterPressed = function(self)
	self:SetAutoFocus(false)
	self:ClearFocus()

	local Value = self:GetText()

	if (Value == "" or Value == " ") then
		self:SetText("|cffB0B0B0Chat...|r")

		return
	end

  SendEvent(format("CHAT_MSG:%s:%s:%s", PlayerName, PlayerClass, Value))
  --print("DEBUG | EBOnEnPressed | PName: ", PlayerName, " // PClass: ", PlayerClass, " // Value: ", Value)

	self:SetText("|cffB0B0B0Chat...|r")
end

local EditBoxOnEnterPressed2 = function(self)
	self:SetAutoFocus(false)
	self:ClearFocus()

	local Value = self:GetText()

	if (Value == "" or Value == " ") then
		self:SetText("|cffB0B0B0Chat...|r")

		return
	end

end

GUI:Hide()

local Close = CreateFrame("Button", nil, GUI)
Close:SetSize(26, 21)
Close:SetPoint("BOTTOMRIGHT", GUI, "BOTTOMRIGHT", 0, 0)
Close:SetFrameStrata("MEDIUM")
SetTemplateDark(Close)
Close:SetScript("OnMouseUp", function(self)
	GUI:Hide()
end)
Close:SetScript("OnEnter", function(self) self.X:SetTextColor(1, 0.1, 0.1) end)
Close:SetScript("OnLeave", function(self) self.X:SetTextColor(unpack(FontColor)) end)

Close.X = Close:CreateFontString(nil, "OVERLAY")
Close.X:SetPoint("CENTER", Close, "CENTER", 0.5, -1)
Close.X:SetFont(Font, 16)
Close.X:SetTextColor(unpack(FontColor))
Close.X:SetText("×")
Close.X:SetShadowOffset(1.25, -1.25)
Close.X:SetShadowColor(0, 0, 0)


local ViewStats = CreateFrame("Button", nil, GUI)
ViewStats:SetSize(26, 21)
ViewStats:SetPoint("BOTTOMLEFT", GUI, "BOTTOMLEFT", 0, 0)
ViewStats:SetFrameStrata("MEDIUM")
SetTemplateDark(ViewStats)
ViewStats:SetScript("OnMouseUp", function(self)
	JaseGambling_OnClickSTATS(full)
end)
ViewStats:SetScript("OnEnter", function(self) self.X:SetTextColor(1, 0.1, 0.1) end)
ViewStats:SetScript("OnLeave", function(self) self.X:SetTextColor(unpack(FontColor)) end)

ViewStats.X = ViewStats:CreateFontString(nil, "OVERLAY")
ViewStats.X:SetPoint("CENTER", ViewStats, "CENTER", 1, -1)
ViewStats.X:SetFont(Font, 16)
ViewStats.X:SetTextColor(unpack(FontColor))
ViewStats.X:SetText("+")
ViewStats.X:SetShadowOffset(1.25, -1.25)
ViewStats.X:SetShadowColor(0, 0, 0)

function JaseGambling_OnLoad(self)
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00<Jase Gambling for WoW!> loaded /jg to use");

	self:RegisterEvent("CHAT_MSG_RAID");
	self:RegisterEvent("CHAT_MSG_CHANNEL");
	self:RegisterEvent("CHAT_MSG_RAID_LEADER");
	self:RegisterEvent("CHAT_MSG_PARTY_LEADER");
	self:RegisterEvent("CHAT_MSG_PARTY");
	self:RegisterEvent("CHAT_MSG_GUILD");
	self:RegisterEvent("CHAT_MSG_SYSTEM");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterForDrag("LeftButton");
    
	RollGame:Disable();
	AcceptRolls:Enable();
	LastCall:Disable();
end

function JaseGambling1:OnInitialize()
	
	local defaults = {
	    global = {
			minimap = {
				hide = false,
			}
		}
	}
    self.db = LibStub("AceDB-3.0"):New("JaseGambling", defaults)
	self:ConstructMiniMapIcon()
end


local EventFrame=CreateFrame("Frame");
EventFrame:RegisterEvent("CHAT_MSG_WHISPER");-- Need to register an event to receive it
EventFrame:SetScript("OnEvent",function(self,event,msg,sender)
    if msg:lower():find("!stats") then--    We're making sure the command is case insensitive by casting it to lowercase before running a pattern check
        ChatMsg("Work in Progress","WHISPER",nil,sender);
    end
end);

local function Print(pre, red, text)
	if red == "" then red = "/JG" end
	DEFAULT_CHAT_FRAME:AddMessage(pre..GREEN_FONT_COLOR_CODE..red..FONT_COLOR_CODE_CLOSE..": "..text)
end

local function DebugMsg(level, text)
  if debugLevel < level then return end

  if level == 1 then
	level = " INFO: "
  elseif level == 2 then
	level = " DEBUG: "
  elseif level == 3 then
	  level = " ERROR: "
  end
  Print("","",GRAY_FONT_COLOR_CODE..date("%H:%M:%S")..RED_FONT_COLOR_CODE..level..FONT_COLOR_CODE_CLOSE..text)
end

local function ChatMsg(msg, chatType, language, channel)
	chatType = chatType or chatmethod
	channelnum = GetChannelName(channel or JaseGambling["channel"] or "gambling")
	SendChatMessage(msg, chatType, language, channelnum)
end

function hide_from_xml()
	JaseGambling_SlashCmd("hide")
	JaseGambling["active"] = 0;
end

function JaseGambling_SlashCmd(msg)
	local msg = msg:lower();
	local msgPrint = 0;
	if (msg == "" or msg == nil) then
	    Print("", "", "~Following commands for JaseGambling~");
		Print("", "", "show - Shows the frame");
		Print("", "", "hide - Hides the frame");
		if (JaseGambling["marks"] == "1") then
			Print("", "", "marks - Toggle Showing Player Marks [Currently Marking]");
		end
		if (JaseGambling["marks"] == "0") then
			Print("", "", "marks - Toggle Showing Player Marks [Not Marking]");
		end
		Print("", "", "reset - Resets the AddOn");
		Print("", "", "fullstats - list full stats");
		Print("", "", "joinstats [main] [alt] - Apply [alt]'s win/losses to [main]");
		Print("", "", "minimap - Toggle minimap show/hide");
		Print("", "", "unjoinstats [alt] - Unjoin [alt]'s win/losses from whomever it was joined to");
		Print("", "", "ban - Ban's the user from being able to roll");
		Print("", "", "unban - Unban's the user");
		Print("", "", "listban - Shows ban list");
		msgPrint = 1;
	end
	if (msg == "hide") then
	    GUI:IsShown();
		GUI:Hide();
		JaseGambling["active"] = 0;
		msgPrint = 1;
	end
	if (msg == "show") then
	GUI:IsShown();
		GUI:Show();
		JaseGambling["active"] = 1;
		msgPrint = 1;
	end
	if (msg == "reset") then
		JaseGambling_Reset();
		JaseGambling_ResetCmd()
		msgPrint = 1;
	end
	if (msg == "fullstats") then
		JaseGambling_OnClickSTATS(true)
		msgPrint = 1;
	end
	if (msg == "minimap") then
		Minimap_Toggle()
		msgPrint = 1;
	end
	if (msg == "marks") then
		Marks_Toggle()
		msgPrint = 1;
	end
	if (string.sub(msg, 1, 9) == "joinstats") then
		JaseGambling_JoinStats(strsub(msg, 11));
		msgPrint = 1;
	end
	if (string.sub(msg, 1, 11) == "unjoinstats") then
		JaseGambling_UnjoinStats(strsub(msg, 13));
		msgPrint = 1;
	end

	if (string.sub(msg, 1, 3) == "ban") then
		JaseGambling_AddBan(strsub(msg, 5));
		msgPrint = 1;
	end

	if (string.sub(msg, 1, 5) == "unban") then
		JaseGambling_RemoveBan(strsub(msg, 7));
		msgPrint = 1;
	end

	if (string.sub(msg, 1, 7) == "listban") then
		JaseGambling_ListBan();
		msgPrint = 1;
	end

	if (msgPrint == 0) then
		Print("", "", "|cffffff00Invalid argument for command /jg");
	end
	
end

SLASH_JaseGambling1 = "/JaseGambling";
SLASH_JaseGambling2 = "/jg";
SlashCmdList["JaseGambling"] = JaseGambling_SlashCmd



function JaseGambling_ParseChatMsg(arg1, arg2)
	if (arg1 == "G" or arg1 =="g") then
		if(JaseGambling_ChkBan(tostring(arg2)) == 0) then
			JaseGambling_Add(tostring(arg2));
			if (not LastCall:Enable() and totalrolls == 1) then
				LastCall:Disable();
			end
			if totalrolls == 2 then
				LastCall:Enable();
			
			end
		else
			ChatMsg("Sorry, but you're banned from the game!");
		end

	elseif(arg1 == "-G" or arg1 == "-g") then
		JaseGambling_Remove(tostring(arg2));
		if (LastCall:Enable() and totalrolls == 0) then
			LastCall:Disable();
		end
		if totalrolls == 1 then
			LastCall:Disable();
		end
	end
end

local function OptionsFormatter(text, prefix)
	if prefix == "" or prefix == nil then prefix = "/JG" end
	DEFAULT_CHAT_FRAME:AddMessage(string.format("%s%s%s: %s", GREEN_FONT_COLOR_CODE, prefix, FONT_COLOR_CODE_CLOSE, text))
end




function JaseGambling_OnEvent(self, event, ...)

	-- LOADS ALL DATA FOR INITIALIZATION OF ADDON --
	if (event == "PLAYER_ENTERING_WORLD") then
		JaseGambling_EditBox:SetJustifyH("CENTER");
		if(not JaseGambling) then
			JaseGambling = {
				["active"] = 0,
				["chat"] = 1,
				["marks"] = "1",
				["whispers"] = false,
				["strings"] = { },
				["lowtie"] = { },
				["hightie"] = { },
				["bans"] = { },
				
			}
		-- fix older legacy items for new chat channels.  Probably need to iterate through each to see if it should be set.
		elseif tostring(type(JaseGambling["chat"])) ~= "number" then
			JaseGambling["chat"] = 1
		end
		if(not JaseGambling["lastroll"]) then JaseGambling["lastroll"] = 100; end
		if(not JaseGambling["GameMode"]) then JaseGambling["GameMode"] = false; end
		if(not JaseGambling["stats"]) then JaseGambling["stats"] = { }; end
		if(not JaseGambling["joinstats"]) then JaseGambling["joinstats"] = { }; end
		if(not JaseGambling["chat"]) then JaseGambling["chat"] = 1; end
		if(not JaseGambling["marks"]) then JaseGambling["marks"] = "1"; end
		if(not JaseGambling["whispers"]) then JaseGambling["whispers"] = false; end
		if(not JaseGambling["bans"]) then JaseGambling["bans"] = { }; end
        

		JaseGambling_EditBox:SetText(""..JaseGambling["lastroll"]);
		chatmethod = chatmethods[JaseGambling["chat"]];
		JaseGambling_CHAT_Button:SetText(chatmethod); 



		if(JaseGambling["whispers"] == false) then

			whispermethod = false;
		else
			JaseGambling_WHISPER_Button:SetText("(Whispers)");
			whispermethod = true;
		end

	end

	-- IF IT'S A RAID MESSAGE... --
	if ((event == "CHAT_MSG_RAID_LEADER" or event == "CHAT_MSG_RAID") and AcceptOnes=="true" and JaseGambling["chat"] == 1) then
		local msg, _,_,_,name = ... -- name no realm
		JaseGambling_ParseChatMsg(msg, name)
	end

	if ((event == "CHAT_MSG_PARTY_LEADER" or event == "CHAT_MSG_PARTY")and AcceptOnes=="true" and JaseGambling["chat"] == 2) then
		local msg, name = ... -- name no realm
		JaseGambling_ParseChatMsg(msg, name)
	end

    if ((event == "CHAT_MSG_GUILD" or event == "CHAT_MSG_GUILD")and AcceptOnes=="true" and JaseGambling["chat"] == 3) then
		local msg, name = ... -- name no realm
		JaseGambling_ParseChatMsg(msg, name)
	end

	if (event == "CHAT_MSG_SYSTEM" and AcceptRolls=="true") then
		local msg = ...
		JaseGambling_ParseRoll(tostring(msg));
	end
end

function Marks_Toggle()
	if (JaseGambling["marks"] == "1") then
			JaseGambling["marks"] = "0";
			Print("", "", "|cffffff00No longer Marking Winners and Losers");
		else
			JaseGambling["marks"] = "1";
			Print("", "", "|cffffff00Now Marking Winners and Losers");
	end
end

function Minimap_Toggle()
	if JaseGambling["minimap"] then
		-- minimap is shown, set to false, and hide
		JaseGambling["minimap"] = false
	    JaseGambling_Frame:Show()
	else
		-- minimap is now shown, set to true, and show
		JaseGambling["minimap"] = true
		JaseGambling_Frame:Hide()
	end
end

function JaseGambling_OnClickCHAT()
	if(JaseGambling["chat"] == nil) then JaseGambling["chat"] = 1; end

	JaseGambling["chat"] = (JaseGambling["chat"] % #chatmethods) + 1;

	chatmethod = chatmethods[JaseGambling["chat"]];
	JaseGambling_CHAT_Button:SetText(chatmethod);
end

function JaseGambling_OnClickWHISPERS()
	if(JaseGambling["whispers"] == nil) then JaseGambling["whispers"] = false; end

	JaseGambling["whispers"] = not JaseGambling["whispers"];

	if(JaseGambling["whispers"] == false) then
		JaseGambling_WHISPER_Button:SetText("(No Whispers)");
		whispermethod = false;
	else
		JaseGambling_WHISPER_Button:SetText("(Whispers)");
		whispermethod = true;
	end
end

function JaseGambling_JoinStats(msg)
	local i = string.find(msg, " ");
	if((not i) or i == -1 or string.find(msg, "[", 1, true) or string.find(msg, "]", 1, true)) then
		ChatFrame1:AddMessage("");
		return;
	end
	local mainname = string.sub(msg, 1, i-1);
	local altname = string.sub(msg, i+1);
	ChatFrame1:AddMessage(string.format("Joined alt '%s' -> main '%s'", altname, mainname));
	JaseGambling["joinstats"][altname] = mainname;
end

function JaseGambling_UnjoinStats(altname)
	if(altname ~= nil and altname ~= "") then
		ChatFrame1:AddMessage(string.format("Unjoined alt '%s' from any other characters", altname));
		JaseGambling["joinstats"][altname] = nil;
	else
		local i, e;
		for i, e in pairs(JaseGambling["joinstats"]) do
			ChatFrame1:AddMessage(string.format("currently joined: alt '%s' -> main '%s'", i, e));
		end
	end
end

function JaseGambling_OnClickSTATS(full)
	local sortlistname = {};
	local sortlistamount = {};
	local n = 0;
	local i, j, k;

	for i, j in pairs(JaseGambling["stats"]) do
		local name = i;
		if(JaseGambling["joinstats"][strlower(i)] ~= nil) then
			name = JaseGambling["joinstats"][strlower(i)]:gsub("^%l", string.upper);
		end
		for k=0,n do
			if(k == n) then
				sortlistname[n] = name;
				sortlistamount[n] = j;
				n = n + 1;
				break;
			elseif(strlower(name) == strlower(sortlistname[k])) then
				sortlistamount[k] = (sortlistamount[k] or 0) + j;
				break;
			end
		end
	end

	if(n == 0) then
		DEFAULT_CHAT_FRAME:AddMessage("No stats yet!");
		return;
	end

	for i = 0, n-1 do
		for j = i+1, n-1 do
			if(sortlistamount[j] > sortlistamount[i]) then
				sortlistamount[i], sortlistamount[j] = sortlistamount[j], sortlistamount[i];
				sortlistname[i], sortlistname[j] = sortlistname[j], sortlistname[i];
			end
		end
	end

	DEFAULT_CHAT_FRAME:AddMessage("--- JaseGambling Stats ---", chatmethod);

	if full then
		for k = 0,  #sortlistamount do
			local sortsign = "won";
			if(sortlistamount[k] < 0) then sortsign = "lost"; end
			ChatMsg(string.format("%d.  %s %s %d total", k+1, sortlistname[k], sortsign, math.abs(sortlistamount[k])), chatmethod);
		end
		return
	end



	local x1 = 5-1;
	local x2 = n-5;
	if(x1 >= n) then x1 = n-1; end
	if(x2 <= x1) then x2 = x1+1; end

	for i = 0, x1 do
		sortsign = "won";
		if(sortlistamount[i] < 0) then sortsign = "lost"; end
		ChatMsg(string.format("%d.  %s %s %d total", i+1, sortlistname[i], sortsign, math.abs(sortlistamount[i])), chatmethod);
	end

	if(x1+1 < x2) then
		ChatMsg("...", chatmethod);
	end

	for i = x2, n-1 do
		sortsign = "won";
		if(sortlistamount[i] < 0) then sortsign = "lost"; end
		ChatMsg(string.format("%d.  %s %s %d total", i+1, sortlistname[i], sortsign, math.abs(sortlistamount[i])), chatmethod);
	end
end

function JaseGambling_OnClickROLL()
	if (totalrolls > 0 and AcceptRolls == "true") then
		if table.getn(JaseGambling.strings) ~= 0 then
			JaseGambling_List();
		end
		return;
	end
	if (totalrolls >1) then
		AcceptOnes = "false";
		AcceptRolls = "true";
		if (tie == 0) then
			ChatMsg(format("Roll %s now!", JaseGambling_EditBox:GetText()));
		end

		if (lowbreak == 1) then
			ChatMsg(format("%s%d%s", "Low end tiebreaker! Roll 1-", theMax, " now!"));
			JaseGambling_List();
		end

		if (highbreak == 1) then
			ChatMsg(format("%s%d%s", "High end tiebreaker! Roll 1-", theMax, " now!"));
			JaseGambling_List();
		end

		JaseGambling_EditBox:ClearFocus();

	end

	if (AcceptOnes == "true" and totalrolls <2) then
		ChatMsg("Not enough Players!");
	end
end

function JaseGambling_OnClickLASTCALL()
	ChatMsg("Last Call to gamble!");
	JaseGambling_EditBox:ClearFocus();
	LastCall:Enable();
	RollGame:Enable();
end

function JaseGambling_OnClickACCEPTONES()
	if JaseGambling_EditBox:GetText() ~= "" and JaseGambling_EditBox:GetText() ~= "G" then
		JaseGambling_Reset();
		RollGame:Disable();
		LastCall:Disable();
		AcceptOnes = "true";
		local fakeroll = "";
		ChatMsg(format("%s%s%s%s", "User's Roll - (", JaseGambling_EditBox:GetText(), ") - Type G to Gamble  (-G to withdraw)", fakeroll));
        	
        if (badbeat_third ~= "") then
			ChatMsg(format("{rt8} %s is up for the Bad Beat Jackpot!", badbeat_third));
			ChatMsg(format("%s gold is owed from everyone rolling if %s wins the bad beat. {rt8}", (JaseGambling_EditBox:GetText() * badbeat_percentage), badbeat_third));
		end
        
        JaseGambling["lastroll"] = JaseGambling_EditBox:GetText();
		theMax = tonumber(JaseGambling_EditBox:GetText());
		low = theMax+1;
		tielow = theMax+1;
		JaseGambling_EditBox:ClearFocus();
		JaseGambling_EditBox:ClearFocus();
	else
		message("Please enter a number to roll from.", chatmethod);
	end
end

function JaseGambling_ParseRoll(temp2)
	local temp1 = strlower(temp2);

	local player, junk, roll, range = strsplit(" ", temp1);

	if junk == "rolls" and JaseGambling_Check(player)==1 then
		minRoll, maxRoll = strsplit("-",range);
		minRoll = tonumber(strsub(minRoll,2));
		maxRoll = tonumber(strsub(maxRoll,1,-2));
		roll = tonumber(roll);
		if (maxRoll == theMax and minRoll == 1) then
			if (tie == 0) then
				if (roll == high) then
					if table.getn(JaseGambling.hightie) == 0 then
						JaseGambling_AddTie(highname, JaseGambling.hightie);
					end
					JaseGambling_AddTie(player, JaseGambling.hightie);
				end
				if (roll>high) then
					highname = player
					highplayername = player
					if (high == 0) then
						high = roll
						if (whispermethod) then
							ChatMsg(string.format("You have the HIGHEST roll so far: %s and you might win a max of %sg", roll, (high - 1)),"WHISPER",GetDefaultLanguage("player"),player);
						end
					else
						high = roll
						if (whispermethod) then
							ChatMsg(string.format("You have the HIGHEST roll so far: %s and you might win %sg from %s", roll, (high - low), lowplayername),"WHISPER",GetDefaultLanguage("player"),player);
							ChatMsg(string.format("%s now has the HIGHEST roller so far: %s and you might owe him/her %sg", player, roll, (high - low)),"WHISPER",GetDefaultLanguage("player"),lowplayername);
						end
					end
					JaseGambling.hightie = {};

				end
				if (roll == low) then
					if table.getn(JaseGambling.lowtie) == 0 then
						JaseGambling_AddTie(lowname, JaseGambling.lowtie);
					end
					JaseGambling_AddTie(player, JaseGambling.lowtie);
				end
				if (roll<low) then
					lowname = player
					lowplayername = player
					low = roll
					if (high ~= low) then
						if (whispermethod) then
							ChatMsg(string.format("You have the LOWEST roll so far: %s and you might owe %s %sg ", roll, highplayername, (high - low)),"WHISPER",GetDefaultLanguage("player"),player);
						end
					end
					JaseGambling.lowtie = {};

				end
			else
				if (lowbreak == 1) then
					if (roll == tielow) then

						if table.getn(JaseGambling.lowtie) == 0 then
							JaseGambling_AddTie(lowname, JaseGambling.lowtie);
						end
						JaseGambling_AddTie(player, JaseGambling.lowtie);
					end
					if (roll<tielow) then
						lowname = player
						tielow = roll;
						JaseGambling.lowtie = {};

					end
				end
				if (highbreak == 1) then
					if (roll == tiehigh) then
						if table.getn(JaseGambling.hightie) == 0 then
							JaseGambling_AddTie(highname, JaseGambling.hightie);
						end
						JaseGambling_AddTie(player, JaseGambling.hightie);
					end
					if (roll>tiehigh) then
						highname = player
						tiehigh = roll;
						JaseGambling.hightie = {};

					end
				end
			end
			JaseGambling_Remove(tostring(player));
			totalentries = totalentries + 1;

			if table.getn(JaseGambling.strings) == 0 then
				if tierolls == 0 then
					JaseGambling_Report();
				else
					if totalentries == 2 then
						JaseGambling_Report();
					else
						JaseGambling_Tiebreaker();
					end
				end
			end
		end
	end
end


function JaseGambling_OnClickACCEPT501()
	if JaseGambling_EditBox2:GetText() ~= "" and JaseGambling_EditBox2:GetText() ~= "G" then
		JaseGambling_Reset();
		RollGame:Disable();
		LastCall:Disable();
		AcceptOnes = "true";
		local fakeroll = "";
		ChatMsg(format("%s%s", "User's Roll ", JaseGambling_EditBox2:GetText()));
		ChatMsg(format("%s%s%s%s", "Type G to Gamble -G to withdraw ", "Current Bet Is ", JaseGambling_EditBox:GetText()," gold"));
		JaseGambling["GameMode"] = JaseGambling_EditBox2:GetText();
		theMax = tonumber(JaseGambling_EditBox2:GetText());
		low = theMax+1;
		tielow = theMax+1;
		JaseGambling_EditBox2:ClearFocus();
		JaseGambling_EditBox2:ClearFocus();
	else
		message("Please enter a number to roll from.", chatmethod);
	end
end


function JaseGambling_OnClickRoll1()
	ChatMsg("G");
end
function JaseGambling_OnClickRoll2()
	ChatMsg("-G");
end

JG_Settings = {
	MinimapPos = 75

}

-- ** do not call from the mod's OnLoad, VARIABLES_LOADED or later is fine. **
function JG_MinimapButton_Reposition()
	JG_MinimapButton:SetPoint("TOPLEFT","Minimap","TOPLEFT",52-(80*cos(JG_Settings.MinimapPos)),(80*sin(JG_Settings.MinimapPos))-52)
end


function JG_MinimapButton_DraggingFrame_OnUpdate()

	local xpos,ypos = GetCursorPosition()
	local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

	xpos = xmin-xpos/UIParent:GetScale()+70
	ypos = ypos/UIParent:GetScale()-ymin-70

	JG_Settings.MinimapPos = math.deg(math.atan2(ypos,xpos))
	JG_MinimapButton_Reposition()
end


function JG_MinimapButton_OnClick()
	DEFAULT_CHAT_FRAME:AddMessage(tostring(arg1).." was clicked.")
end

function JaseGambling_Report()
	local goldowed = high - low
	local GameMode2 = ""
	if (JaseGambling["GameMode"]) then
	GameMode2 = floor(JaseGambling_EditBox:GetText())
	goldowed = goldowed - GameMode2
	goldowed = high - low
	JaseGambling["GameMode1"]  = (JaseGambling["GameMode1"] or 0);
	else 
	GameMode2 = floor(goldowed)
	goldowed = high - low
	end
	if (goldowed ~= 0) then
    
		if (badbeat_third ~= lowname:gsub("^%l", string.upper)) then
			badbeat_success = 0;
			badbeat_third = "";
		end
        if (badbeat_third == lowname:gsub("^%l", string.upper)) then 
            badbeat_success = 1;
			badbeat_close = 0;
        end
        if (badbeat_second == lowname:gsub("^%l", string.upper)) then 
            badbeat_third = badbeat_second;
            badbeat_first = "";
			badbeat_close = 1;
        end
        
		lowname = lowname:gsub("^%l", string.upper)
		highname = highname:gsub("^%l", string.upper)
        badbeat_second = lowname;
        totaljackpot = (totalentries - 1);
        totaljackpotgold = (totaljackpot * (JaseGambling_EditBox:GetText() * badbeat_percentage));
        
local string3 = string.format("[{rt3} %s]  owes  [{rt1} %s]  %s gold! %s ", lowname, highname, (GameMode2),"");
local stringbadbeat = string.format("{rt8} Everyone owes  [{rt7} %s]  %s gold! For winning the Bad Beat Jackpot!  (%s Gold Won!)  {rt8}", lowname, (JaseGambling_EditBox:GetText() * badbeat_percentage), totaljackpotgold);
local stringbadbeatlost = string.format("Badbeat unsuccessful - %s Gold Missed!", totaljackpotgold);

		if (JaseGambling["marks"] == "1") then
			SetRaidTarget(highname, 1);
			SetRaidTarget(lowname, 3);
		end

		JaseGambling["stats"][highname] = (JaseGambling["stats"][highname] or 0) + GameMode2;
		JaseGambling["stats"][lowname] = (JaseGambling["stats"][lowname] or 0) - GameMode2;
        if (badbeat_success == 1) then
            JaseGambling["stats"][lowname] = (JaseGambling["stats"][lowname] or 0) + totaljackpotgold;
        end

		ChatMsg(string3);
		
	if (badbeat_third ~= lowname:gsub("^%l", string.upper)) then
		if (badbeat_close == 1) then	
			ChatMsg(stringbadbeatlost);
			badbeat_third = "";
			badbeat_second = "";
			SetRaidTarget(lowname, 7);
			totaljackpot= "";
			totaljackpotgold= "";
			badbeat_close = 0;
		end
	end
	
    if (badbeat_success == 1) then	
        ChatMsg(stringbadbeat);
        badbeat_third = "";
        badbeat_second = "";
        SetRaidTarget(lowname, 7);
        totaljackpot= "";
        totaljackpotgold= "";
        badbeat_success = 0;
    end
        
	else
		ChatMsg("It was a tie! No payouts on this roll!");
	end
end



function JaseGambling_Report2()
print(name,"rolled a",roll,"out of",minRoll,"to",maxRoll)
end



function JaseGambling_Tiebreaker()
	tierolls = 0;
	totalrolls = 0;
	tie = 1;
	if table.getn(JaseGambling.lowtie) == 1 then
		JaseGambling.lowtie = {};
	end
	if table.getn(JaseGambling.hightie) == 1 then
		JaseGambling.hightie = {};
	end
	totalrolls = table.getn(JaseGambling.lowtie) + table.getn(JaseGambling.hightie);
	tierolls = totalrolls;
	if (table.getn(JaseGambling.hightie) == 0 and table.getn(JaseGambling.lowtie) == 0) then
		JaseGambling_Report();
	else
		AcceptRolls = "false";
		if table.getn(JaseGambling.lowtie) > 0 then
			lowbreak = 1;
			highbreak = 0;
			tielow = theMax+1;
			tiehigh = 0;
			JaseGambling.strings = JaseGambling.lowtie;
			JaseGambling.lowtie = {};
			JaseGambling_OnClickROLL();
		end
		if table.getn(JaseGambling.hightie) > 0  and table.getn(JaseGambling.strings) == 0 then
			lowbreak = 0;
			highbreak = 1;
			tielow = theMax+1;
			tiehigh = 0;
			JaseGambling.strings = JaseGambling.hightie;
			JaseGambling.hightie = {};
			JaseGambling_OnClickROLL();
		end
	end
end

function JaseGambling_Check(player)
	for i=1, table.getn(JaseGambling.strings) do
		if strlower(JaseGambling.strings[i]) == tostring(player) then
			return 1
		end
	end
	return 0
end

function JaseGambling_List()
	for i=1, table.getn(JaseGambling.strings) do
	  	local string3 = strjoin(" ", "", tostring(JaseGambling.strings[i]):gsub("^%l", string.upper),format("still needs to roll %s!", JaseGambling_EditBox:GetText())) 
		ChatMsg(string3);
	end
end

function JaseGambling_ListBan()
	local bancnt = 0;
	Print("", "", "|cffffff00To ban do /jg ban (Name) or to unban /jg unban (Name) - The Current Bans:");
	for i=1, table.getn(JaseGambling.bans) do
		bancnt = 1;
		DEFAULT_CHAT_FRAME:AddMessage(strjoin("|cffffff00", "...", tostring(JaseGambling.bans[i])));
	end
	if (bancnt == 0) then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffff00To ban do /jg ban (Name) or to unban /jg unban (Name).");
	end
end

function JaseGambling_Add(name)
	local charname, realmname = strsplit("-",name);
	local insname = strlower(charname);
	if (insname ~= nil or insname ~= "") then
		local found = 0;
		for i=1, table.getn(JaseGambling.strings) do
		  	if JaseGambling.strings[i] == insname then
				found = 1;
			end
        	end
		if found == 0 then
		      	table.insert(JaseGambling.strings, insname)
			totalrolls = totalrolls+1
		end
	end
end

function JaseGambling_ChkBan(name)
	local charname, realmname = strsplit("-",name);
	local insname = strlower(charname);
	if (insname ~= nil or insname ~= "") then
		for i=1, table.getn(JaseGambling.bans) do
			if strlower(JaseGambling.bans[i]) == strlower(insname) then
				return 1
			end
		end
	end
	return 0
end

function JaseGambling_AddBan(name)
	local charname, realmname = strsplit("-",name);
	local insname = strlower(charname);
	if (insname ~= nil or insname ~= "") then
		local banexist = 0;
		for i=1, table.getn(JaseGambling.bans) do
			if JaseGambling.bans[i] == insname then
				Print("", "", "|cffffff00Unable to add to ban list - user already banned.");
				banexist = 1;
			end
		end
		if (banexist == 0) then
			table.insert(JaseGambling.bans, insname)
			Print("", "", "|cffffff00User is now banned!");
			local string3 = strjoin(" ", "", "User Banned from rolling! -> ",insname, "!")
			DEFAULT_CHAT_FRAME:AddMessage(strjoin("|cffffff00", string3));
		end
	else
		Print("", "", "|cffffff00Error: No name provided.");
	end
end

function JaseGambling_RemoveBan(name)
	local charname, realmname = strsplit("-",name);
	local insname = strlower(charname);
	if (insname ~= nil or insname ~= "") then
		for i=1, table.getn(JaseGambling.bans) do
			if strlower(JaseGambling.bans[i]) == strlower(insname) then
				table.remove(JaseGambling.bans, i)
				Print("", "", "|cffffff00User removed from ban successfully.");
				return;
			end
		end
	else
		Print("", "", "|cffffff00Error: No name provided.");
	end
end

function JaseGambling_AddTie(name, tietable)
	local charname, realmname = strsplit("-",name);
	local insname = strlower(charname);
	if (insname ~= nil or insname ~= "") then
		local found = 0;
		for i=1, table.getn(tietable) do
		  	if tietable[i] == insname then
				found = 1;
			end
        	end
		if found == 0 then
		    table.insert(tietable, insname)
			tierolls = tierolls+1
			totalrolls = totalrolls+1
		end
	end
end

function JaseGambling_Remove(name)
	local charname, realmname = strsplit("-",name);
	local insname = strlower(charname);
	for i=1, table.getn(JaseGambling.strings) do
		if JaseGambling.strings[i] ~= nil then
		  	if strlower(JaseGambling.strings[i]) == strlower(insname) then
				table.remove(JaseGambling.strings, i)
				totalrolls = totalrolls - 1;
			end
		end
      end
end

function JaseGambling_RemoveTie(name, tietable)
	local charname, realmname = strsplit("-",name);
	local insname = strlower(charname);
	for i=1, table.getn(tietable) do
		if tietable[i] ~= nil then
		  	if strlower(tietable[i]) == insname then
				table.remove(tietable, i)
			end
		end
      end
end

function JaseGambling_Reset()
		JaseGambling["strings"] = { };
		JaseGambling["lowtie"] = { };
		JaseGambling["hightie"] = { };
		AcceptOnes = "false"
		AcceptRolls = "false"
		totalrolls = 0
		theMax = 0
		tierolls = 0;
		lowname = ""
		highname = ""
		low = theMax
		high = 0
		tie = 0
		lastroll = 100;
		highbreak = 0;
		lowbreak = 0;
		tiehigh = 0;
		tielow = 0;
		totalentries = 0;
		highplayername = "";
		lowplayername = "";
		RollGame:Disable();
		LastCall:Disable();
		Print("", "", "|cffffff00Roll has now been reset");

end

function JaseGambling_ResetCmd()
	ChatMsg(".:JaseGambling:. Game has been reset", chatmethod)
end

function JaseGambling_EditBox_OnLoad()
    JaseGambling_EditBox:SetNumeric(true);
	JaseGambling_EditBox:SetAutoFocus(false);

end

function JaseGambling_EditBox_OnEnterPressed()
    JaseGambling_EditBox:ClearFocus();
	lastroll = "";
end
