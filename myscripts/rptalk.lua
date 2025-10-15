require('encoding').default = 'CP1251'
local u8 = require('encoding').UTF8
local inicfg = require('inicfg')
local sampev = require("lib.samp.events")

script_name("RolePlay Talk")
script_author("justskipty")
script_description(u8"� ��������� ����� - /rptalk, � ��������� ����� � � ������ - /rptalkdot")

local cfg_file = "rptalk_config"
local cfg = inicfg.load({
    settings = {
        enabled = false,
        add_dot = false
    }
}, cfg_file)

local russian_characters = {
    [168] = '�', [184] = '�', [192] = '�', [193] = '�', [194] = '�', [195] = '�', [196] = '�', [197] = '�', [198] = '�', [199] = '�',
    [200] = '�', [201] = '�', [202] = '�', [203] = '�', [204] = '�', [205] = '�', [206] = '�', [207] = '�', [208] = '�', [209] = '�',
    [210] = '�', [211] = '�', [212] = '�', [213] = '�', [214] = '�', [215] = '�', [216] = '�', [217] = '�', [218] = '�', [219] = '�',
    [220] = '�', [221] = '�', [222] = '�', [223] = '�', [224] = '�', [225] = '�', [226] = '�', [227] = '�', [228] = '�', [229] = '�',
    [230] = '�', [231] = '�', [232] = '�', [233] = '�', [234] = '�', [235] = '�', [236] = '�', [237] = '�', [238] = '�', [239] = '�',
    [240] = '�', [241] = '�', [242] = '�', [243] = '�', [244] = '�', [245] = '�', [246] = '�', [247] = '�', [248] = '�', [249] = '�',
    [250] = '�', [251] = '�', [252] = '�', [253] = '�', [254] = '�', [255] = '�'
}

function main()
    repeat wait(0) until isSampAvailable()

    sampRegisterChatCommand("rptalk", function()
        cfg.settings.enabled = not cfg.settings.enabled
        cfg.settings.add_dot = false
        inicfg.save(cfg, cfg_file)

        if cfg.settings.enabled then
            sampAddChatMessage("[RpTalk] �������. ��������� ���������� � ��������� ����� (��� �����).", 0x00FF00)
        else
            sampAddChatMessage("[RpTalk] ��������. RP-����� ��������.", 0xAAAAAA)
        end
    end)

    sampRegisterChatCommand("rptalkdot", function()
        cfg.settings.enabled = not cfg.settings.enabled
        cfg.settings.add_dot = cfg.settings.enabled
        inicfg.save(cfg, cfg_file)

        if cfg.settings.enabled then
            sampAddChatMessage("[RpTalk] �������. ��������� ���������� � ��������� ����� � ������������� ������.", 0x00FF00)
        else
            sampAddChatMessage("[RpTalk] ��������. RP-����� ��������.", 0xAAAAAA)
        end
    end)

    if cfg.settings.enabled then
        if cfg.settings.add_dot then
            sampAddChatMessage("[RpTalk] ������� �����: ��������� + �����.", 0x00FF00)
        else
            sampAddChatMessage("[RpTalk] ������� �����: ��������� ��� �����.", 0x00FF00)
        end
    else
        sampAddChatMessage("[RpTalk] ������ ��������. RP-����� ��������.", 0xAAAAAA)
    end

    wait(-1)
end

function sampev.onSendChat(text)
    if cfg.settings.enabled and text:len() > 0 then
        text = text:sub(1, 1):rupper() .. text:sub(2)
        if cfg.settings.add_dot and not text:find('[%.%!%?]$') then
            text = text .. '.'
        end
        return {text}
    end
end

function string.rupper(s)
    local strlen = s:len()
    if strlen == 0 then return s end
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 224 and ch <= 255 then
            output = output .. russian_characters[ch - 32]
        elseif ch == 184 then
            output = output .. russian_characters[168]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end