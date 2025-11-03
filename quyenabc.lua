--[[
    All-in-One Chat Translator with UI (Compact & Searchable Version)
    - Translates outgoing messages to a selected language or into a "Jumble" mode.
    - Translates incoming messages into English.
    - Features a compact, draggable, and collapsible UI with 100 languages
      visually separated by category.
    - NEW: Includes a search bar to instantly filter the language list.
--]]

-- Wait for the game to be fully loaded.
if not game:IsLoaded() then game.Loaded:Wait() end
-- Hiển thị "by quyendz" ở giữa màn hình, mờ dần sau 3 giây
do
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local creditGui = Instance.new("ScreenGui")
    creditGui.Name = "QuyendzCredit"
    creditGui.IgnoreGuiInset = true
    creditGui.ResetOnSpawn = false
    creditGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    creditGui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Parent = creditGui
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Position = UDim2.new(0,0,0,0)

    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = frame
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Position = UDim2.new(0,0,0,0)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Text = "by quyendz"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 48
    textLabel.TextStrokeTransparency = 0.6
    textLabel.TextTransparency = 0
    textLabel.TextYAlignment = Enum.TextYAlignment.Center
    textLabel.TextXAlignment = Enum.TextXAlignment.Center

    -- print to console when script loads
    print("made by quyendz")

    -- Fade out after 3 seconds total (0 to 3s visible, then fade during ~0.5-1s)
    task.spawn(function()
        -- Wait 3 seconds visible
        task.wait(3)
        -- Fade out over 0.6s using TweenService for smoother effect
        local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(textLabel, tweenInfo, {TextTransparency = 1})
        local tween2 = TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 1})
        tween:Play()
        tween2:Play()
        tween.Completed:Wait()
        creditGui:Destroy()
    end)
end

repeat task.wait(.06) until game:GetService("Players").LocalPlayer

-- Services
local Http = game:GetService("HttpService")
local Players = game:GetService("Players")
local TCS = game:GetService("TextChatService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- Translator State
local isTranslatorActive = false -- Translator is disabled by default.
local isJumbleActive = false -- Jumble mode is disabled by default.
local yourLanguage = "en" -- Language for incoming messages.
local targetLanguage = nil -- Target language for your outgoing messages (starts as none).

-- A structured array of tables,
-- This new structure allows us. to build the UI in a specific order.
local languageCategories = {
    {
        Name = "Global & Constructed",
        Languages = {
            ["English (USA/UK)"] = "en",
            ["Esperanto (Global)"] = "eo",
            ["Latin (Global)"] = "la"
        }
    },
    {
        Name = "African Languages",
        Languages = {
            ["Afrikaans (South Africa)"] = "af",
            ["Amharic (Ethiopia)"] = "am",
            ["Hausa (Nigeria)"] = "ha",
            ["Igbo (Nigeria)"] = "ig",
            ["Malagasy (Madagascar)"] = "mg",
            ["Sesotho (Lesotho)"] = "st",
            ["Shona (Zimbabwe)"] = "sn",
            ["Somali (Somalia)"] = "so",
            ["Swahili (Tanzania/Kenya)"] = "sw",
            ["Xhosa (South Africa)"] = "xh",
            ["Yoruba (Nigeria)"] = "yo",
            ["Zulu (South Africa)"] = "zu"
        }
    },
    {
        Name = "Asian Languages",
        Languages = {
            ["Armenian (Armenia)"] = "hy",
            ["Azerbaijani (Azerbaijan)"] = "az",
            ["Bengali (Bangladesh)"] = "bn",
            ["Burmese (Myanmar)"] = "my",
            ["Chinese (China)"] = "zh-cn",
            ["Georgian (Georgia)"] = "ka",
            ["Gujarati (India)"] = "gu",
            ["Hindi (India)"] = "hi",
            ["Hmong (China/Vietnam)"] = "hmn",
            ["Indonesian (Indonesia)"] = "id",
            ["Japanese (Japan)"] = "ja",
            ["Javanese (Indonesia)"] = "jw",
            ["Kannada (India)"] = "kn",
            ["Kazakh (Kazakhstan)"] = "kk",
            ["Khmer (Cambodia)"] = "km",
            ["Korean (South Korea)"] = "ko",
            ["Kurdish (Kurdistan)"] = "ku",
            ["Kyrgyz (Kyrgyzstan)"] = "ky",
            ["Lao (Laos)"] = "lo",
            ["Malay (Malaysia)"] = "ms",
            ["Malayalam (India)"] = "ml",
            ["Marathi (India)"] = "mr",
            ["Mongolian (Mongolia)"] = "mn",
            ["Nepali (Nepal)"] = "ne",
            ["Pashto (Afghanistan)"] = "ps",
            ["Punjabi (India/Pakistan)"] = "pa",
            ["Sindhi (Pakistan)"] = "sd",
            ["Sinhala (Sri Lanka)"] = "si",
            ["Sundanese (Indonesia)"] = "su",
            ["Tajik (Tajikistan)"] = "tg",
            ["Tamil (India/Sri Lanka)"] = "ta",
            ["Telugu (India)"] = "te",
            ["Thai (Thailand)"] = "th",
            ["Urdu (Pakistan/India)"] = "ur",
            ["Uzbek (Uzbekistan)"] = "uz",
            ["Vietnamese (Vietnam)"] = "vi"
        }
    },
    {
        Name = "European Languages",
        Languages = {
            ["Albanian (Albania)"] = "sq",
            ["Basque (Spain/France)"] = "eu",
            ["Belarusian (Belarus)"] = "be",
            ["Bosnian (Bosnia)"] = "bs",
            ["Bulgarian (Bulgaria)"] = "bg",
            ["Catalan (Spain)"] = "ca",
            ["Corsican (France)"] = "co",
            ["Croatian (Croatia)"] = "hr",
            ["Czech (Czechia)"] = "cs",
            ["Danish (Denmark)"] = "da",
            ["Dutch (Netherlands)"] = "nl",
            ["Estonian (Estonia)"] = "et",
            ["Finnish (Finland)"] = "fi",
            ["French (France/Canada)"] = "fr",
            ["Frisian (Netherlands)"] = "fy",
            ["Galician (Spain)"] = "gl",
            ["German (Germany)"] = "de",
            ["Greek (Greece)"] = "el",
            ["Hungarian (Hungary)"] = "hu",
            ["Icelandic (Iceland)"] = "is",
            ["Irish (Ireland)"] = "ga",
            ["Italian (Italy)"] = "it",
            ["Latvian (Latvia)"] = "lv",
            ["Lithuanian (Lithuania)"] = "lt",
            ["Luxembourgish (Luxembourg)"] = "lb",
            ["Macedonian (N. Macedonia)"] = "mk",
            ["Maltese (Malta)"] = "mt",
            ["Norwegian (Norway)"] = "no",
            ["Polish (Poland)"] = "pl",
            ["Portuguese (Portugal/Brazil)"] = "pt",
            ["Romanian (Romania)"] = "ro",
            ["Russian (Russia)"] = "ru",
            ["Scots Gaelic (Scotland)"] = "gd",
            ["Serbian (Serbia)"] = "sr",
            ["Slovak (Slovakia)"] = "sk",
            ["Slovenian (Slovenia)"] = "sl",
            ["Spanish (Spain/Mexico)"] = "es",
            ["Swedish (Sweden)"] = "sv",
            ["Ukrainian (Ukraine)"] = "uk",
            ["Welsh (Wales)"] = "cy"
        }
    },
    {
        Name = "Middle Eastern Languages",
        Languages = {
            ["Arabic (Saudi Arabia)"] = "ar",
            ["Hebrew (Israel)"] = "iw",
            ["Persian (Iran)"] = "fa",
            ["Turkish (Turkey)"] = "tr",
            ["Yiddish (Israel/USA)"] = "yi"
        }
    },
    {
        Name = "North & Central American",
        Languages = {
            ["Haitian Creole (Haiti)"] = "ht"
        }
    },
    {
        Name = "Oceanian Languages",
        Languages = {
            ["Cebuano (Philippines)"] = "ceb",
            ["Filipino (Philippines)"] = "tl",
            ["Hawaiian (USA)"] = "haw",
            ["Maori (New Zealand)"] = "mi",
            ["Samoan (Samoa)"] = "sm"
        }
    }
}

-- Create flat tables for the existing logic to use.
-- 'languages' maps the full name "Language (Country)" to its code "lg".
-- 'langCodesArray' is just a list of all codes for Jumble mode.
local languages = {}
local langCodesArray = {}

for _, categoryData in ipairs(languageCategories) do
    for langName, langCode in pairs(categoryData.Languages) do
        languages[langName] = langCode
        table.insert(langCodesArray, langCode)
    end
end

--region Translation API Functions
-- This section handles the connection to the translation service.

local gv -- Google consent value.
local function req(opt)
	local fn = (syn and syn.request) or (http and http.request) or http_request or request
	if fn then return fn(opt) end
	return Http:RequestAsync(opt)
end

local function consent(body)
	local t = {}
	for tag in body:gmatch('<input type="hidden" name=".-" value=".-">') do
		local k, v = tag:match('<input type="hidden" name="(.-)" value="(.-)">')
		t[k] = v
	end
	gv = t.v or ""
end

local function got(url, method, body)
	method = method or "GET"
	local res = req({Url = url, Method = method, Headers = {cookie = "CONSENT=YES+" .. (gv or "")}, Body = body})
	local b = res.Body or res.body or ""
	if type(b) ~= "string" then b = tostring(b) end
	if b:match("https://consent.google.com/s") then
		consent(b)
		res = req({Url = url, Method = "GET", Headers = {cookie = "CONSENT=YES+" .. (gv or "")}})
	end
	return res
end

local function q(data)
	local s = ""
	for k, v in pairs(data) do
		if type(v) == "table" then
			for _, vv in pairs(v) do s ..= "&" .. Http:UrlEncode(k) .. "=" .. Http:UrlEncode(vv) end
		else
			s ..= "&" .. Http:UrlEncode(k) .. "=" .. Http:UrlEncode(v)
		end
	end
	return s:sub(2)
end

local jE = function(x) return Http:JSONEncode(x) end
local jD = function(x) return Http:JSONDecode(x) end

local rpc = "MkEWBc"
local root = "https://translate.google.com/"
local exec = "https://translate.google.com/_/TranslateWebserverUi/data/batchexecute"

local fsid, bl, rid = nil, nil, math.random(1000, 9999)
do
	local b = (got(root).Body or "")
	fsid = b:match('"FdrFJe":"(.-)"')
	bl = b:match('"cfb2h":"(.-)"')
end

local function translate(txt, tgt, src)
	rid += 10000
	src = src or "auto"
	local data = {{txt, src, tgt, true}, {nil}}
	local freq = {{{rpc, jE(data), nil, "generic"}}}
	local url = exec .. "?" .. q{rpcids = rpc, ["f.sid"] = fsid, bl = bl, hl = "en", _reqID = rid - 10000, rt = "c"}
	local body = q{["f.req"] = jE(freq)}
	local res = got(url, "POST", body)
	local ok, out = pcall(function()
		local arr = jD((res.Body or ""):match("%[.-%]\n"))
		return jD(arr[1][3])
	end)
	if not ok then return nil end
	return out[2][1][1][6][1][1]
end

local function translateInfo(txt, tgt, src)
	rid += 10000
	src = src or "auto"
	local data = {{txt, src, tgt, true}, {nil}}
	local freq = {{{rpc, jE(data), nil, "generic"}}}
	local url = exec .. "?" .. q{rpcids = rpc, ["f.sid"] = fsid, bl = bl, hl = "en", _reqID = rid - 10000, rt = "c"}
	local body = q{["f.req"] = jE(freq)}
	local res = got(url, "POST", body)
	local ok, out = pcall(function()
		local arr = jD((res.Body or ""):match("%[.-%]\n"))
		return jD(arr[1][3])
	end)
	if not ok or not out then return nil, nil end
	return out[2][1][1][6][1][1], out[3]
end

--endregion

--region Chat Helper Functions
-- This section manages sending messages and interacting with the chat UI.

local function sys(msg)
	local chans = TCS:WaitForChild("TextChannels", 60)
	if not chans then return end
	local c = chans:FindFirstChild("RBXSystem") or chans:FindFirstChild("RBXGeneral") or chans:GetChildren()[1]
	if c and c.DisplaySystemMessage then
		c:DisplaySystemMessage(msg)
	end
end

local function defaultChannel()
	return TCS.TextChannels:FindFirstChild("RBXGeneral") or TCS.TextChannels:FindFirstChild("General") or TCS.TextChannels:FindFirstChild("RBXSystem")
end

local function sendChat(text)
	task.spawn(function()
		local chan = defaultChannel()
		if chan then
			chan:SendAsync(text)
		end
	end)
end

-- This function intercepts your outgoing chat messages to perform translation.
local function handleOutgoing(rawMessage)
	-- Ignore commands (e.g., /w, /team).
	if rawMessage:sub(1, 1) == "/" then return false end

	-- Jumble mode is for fun. It translates each word separately into a random language.
	-- This mode intentionally breaks grammar and punctuation.
	if isJumbleActive then
		local words = {}
		for word in rawMessage:gmatch("%S+") do
			table.insert(words, word)
		end
		
		local translatedWords = {}
		for _, word in ipairs(words) do
			local randomLangCode = langCodesArray[math.random(#langCodesArray)]
			local translatedWord = translate(word, randomLangCode, "auto") or word
			table.insert(translatedWords, translatedWord)
		end
		
		sendChat(table.concat(translatedWords, " "))
		return true

	-- Standard translator mode.
	elseif isTranslatorActive and targetLanguage then
		-- The entire message (rawMessage) is sent to the translation function.
		-- This provides context, allowing the API to handle grammar, word order, and
		-- punctuation correctly, resulting in a much more natural and accurate translation.
		local translatedText = translate(rawMessage, targetLanguage, "auto") or rawMessage
		sendChat(translatedText)
		return true
	end

	-- If the translator is off, the message is sent normally.
	return false
end

--endregion

--region UI Creation
-- This section creates the graphical user interface.

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TranslatorUI"
screenGui.Parent = CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
mainFrame.BorderSizePixel = 1
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.Size = UDim2.new(0, 280, 0, 30)
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Parent = mainFrame
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Size = UDim2.new(0, 100, 0, 30)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "Translator"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Parent = mainFrame
toggleButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
toggleButton.Size = UDim2.new(0, 25, 0, 20)
toggleButton.Position = UDim2.new(1, -30, 0.5, -10)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Text = "[+]"
toggleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
toggleButton.TextSize = 16
toggleButton.ZIndex = 2

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Parent = mainFrame
scrollFrame.BackgroundTransparency = 1
scrollFrame.Position = UDim2.new(0, 0, 0, 30)
scrollFrame.Size = UDim2.new(1, 0, 1, -30)
scrollFrame.Visible = false
scrollFrame.ZIndex = 1
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
scrollFrame.ScrollBarThickness = 6
scrollFrame.BorderSizePixel = 0

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)

local controlFrame = Instance.new("Frame")
controlFrame.Name = "ControlFrame"
controlFrame.Parent = scrollFrame
controlFrame.BackgroundTransparency = 1
controlFrame.Size = UDim2.new(1, 0, 0, 30) -- Height for one row of buttons
controlFrame.AutomaticSize = Enum.AutomaticSize.Y
controlFrame.LayoutOrder = 1 -- Place this at the top.

local controlGrid = Instance.new("UIGridLayout")
controlGrid.Parent = controlFrame
controlGrid.CellPadding = UDim2.new(0, 5, 0, 5)
controlGrid.CellSize = UDim2.new(0, 85, 0, 25)
controlGrid.StartCorner = Enum.StartCorner.TopLeft
controlGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
controlGrid.SortOrder = Enum.SortOrder.LayoutOrder

local stopButton = Instance.new("TextButton")
stopButton.Name = "StopButton"
stopButton.Parent = controlFrame
stopButton.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
stopButton.BorderColor3 = Color3.fromRGB(80, 80, 80)
stopButton.Font = Enum.Font.SourceSansBold
stopButton.Text = "Stop"
stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopButton.TextSize = 14
stopButton.LayoutOrder = 1 -- First item in this grid.

local jumbleButton = Instance.new("TextButton")
jumbleButton.Name = "JumbleButton"
jumbleButton.Parent = controlFrame
jumbleButton.BackgroundColor3 = Color3.fromRGB(120, 60, 180) -- A unique purple color.
jumbleButton.BorderColor3 = Color3.fromRGB(80, 80, 80)
jumbleButton.Font = Enum.Font.SourceSansBold
jumbleButton.Text = "Jumble"
jumbleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
jumbleButton.TextSize = 14
jumbleButton.LayoutOrder = 2 -- Second item in this grid.

-- NEW: Add a search bar
local searchBoxFrame = Instance.new("Frame")
searchBoxFrame.Name = "SearchBoxFrame"
searchBoxFrame.Parent = scrollFrame
searchBoxFrame.BackgroundTransparency = 1
searchBoxFrame.Size = UDim2.new(1, -10, 0, 25)
searchBoxFrame.Position = UDim2.new(0, 5, 0, 0)
searchBoxFrame.LayoutOrder = 2 -- Place it after controls.

local searchBoxLabel = Instance.new("TextLabel")
searchBoxLabel.Name = "SearchLabel"
searchBoxLabel.Parent = searchBoxFrame
searchBoxLabel.BackgroundTransparency = 1
searchBoxLabel.Size = UDim2.new(0, 60, 1, 0)
searchBoxLabel.Font = Enum.Font.SourceSans
searchBoxLabel.Text = "Search: "
searchBoxLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
searchBoxLabel.TextSize = 14
searchBoxLabel.TextXAlignment = Enum.TextXAlignment.Left

local searchBox = Instance.new("TextBox")
searchBox.Name = "SearchBox"
searchBox.Parent = searchBoxFrame
searchBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
searchBox.BorderColor3 = Color3.fromRGB(80, 80, 80)
searchBox.Position = UDim2.new(0, 60, 0, 0)
searchBox.Size = UDim2.new(1, -65, 1, 0)
searchBox.Font = Enum.Font.SourceSans
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(240, 240, 240)
searchBox.TextSize = 14
searchBox.PlaceholderText = "Type to filter..."
searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
searchBox.ClearTextOnFocus = false

-- This table will store all button instances for the click logic.
local langButtons = {}
-- NEW: This table stores UI elements by category for filtering.
local categoryElements = {}
local categoryLayoutOrder = 3 -- Start after the control frame and search bar.

-- CHANGE: Loop through the new 'languageCategories' array to build the UI.
for _, categoryData in ipairs(languageCategories) do
    
    -- 1. Create the Category Header (e.g., "Asian Languages")
    local headerLabel = Instance.new("TextLabel")
    headerLabel.Name = categoryData.Name .. "Header"
    headerLabel.Parent = scrollFrame
    headerLabel.BackgroundTransparency = 1
    headerLabel.Size = UDim2.new(1, -10, 0, 20)
    headerLabel.Position = UDim2.new(0, 5, 0, 0)
    headerLabel.Font = Enum.Font.SourceSansBold
    headerLabel.Text = categoryData.Name
    headerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    headerLabel.TextSize = 16
    headerLabel.TextXAlignment = Enum.TextXAlignment.Left
    headerLabel.LayoutOrder = categoryLayoutOrder
    categoryLayoutOrder += 1
    
    -- 2. Create a container Frame for this category's buttons
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = categoryData.Name .. "Container"
    buttonContainer.Parent = scrollFrame
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Size = UDim2.new(1, 0, 0, 50) -- Height will be set by AutomaticSize
    buttonContainer.AutomaticSize = Enum.AutomaticSize.Y
    buttonContainer.LayoutOrder = categoryLayoutOrder
    categoryLayoutOrder += 1
    
    -- 3. Add a UIGridLayout to this specific container
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.Parent = buttonContainer
    gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
    gridLayout.CellSize = UDim2.new(0, 85, 0, 25)
    gridLayout.StartCorner = Enum.StartCorner.TopLeft
    gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    gridLayout.SortOrder = Enum.SortOrder.Name -- Sort alphabetically within the category.
    
    -- 4. Get, sort, and create the buttons for this category
    local sortedLangNames = {}
    for langName in pairs(categoryData.Languages) do
        table.insert(sortedLangNames, langName)
    end
    table.sort(sortedLangNames)
    
    -- NEW: Store buttons locally for this category
    local categoryButtons = {}
    for _, langName in ipairs(sortedLangNames) do
        local button = Instance.new("TextButton")
        button.Name = langName
        button.Parent = buttonContainer
        button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        button.BorderColor3 = Color3.fromRGB(80, 80, 80)
        button.Font = Enum.Font.SourceSans
        button.Text = langName
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 12
        langButtons[langName] = button -- Add to the master list for click logic.
        categoryButtons[langName] = button -- NEW: Add to local list for filter logic.
    end
    
    -- NEW: Add the category's UI elements to the filter table
    table.insert(categoryElements, {
        header = headerLabel,
        container = buttonContainer,
        buttons = categoryButtons
    })
end

--endregion

--region UI Logic

-- NEW: Function to filter the list based on search text
local function updateFilter(searchText)
    local searchTextLower = string.lower(searchText)
    
    -- If search is empty, show everything
    if searchTextLower == "" then
        for _, category in ipairs(categoryElements) do
            category.header.Visible = true
            category.container.Visible = true
            for _, button in pairs(category.buttons) do
                button.Visible = true
            end
        end
        return
    end
    
    -- If search has text, filter
    for _, category in ipairs(categoryElements) do
        local anyButtonVisible = false
        
        -- Check each button in this category
        for langName, button in pairs(category.buttons) do
            local langNameLower = string.lower(langName)
            if string.find(langNameLower, searchTextLower) then
                button.Visible = true
                anyButtonVisible = true
            else
                button.Visible = false
            end
        end
        
        -- Show/hide the category header and container
        category.header.Visible = anyButtonVisible
        category.container.Visible = anyButtonVisible
    end
end

local isExpanded = false
toggleButton.MouseButton1Click:Connect(function()
    isExpanded = not isExpanded
    scrollFrame.Visible = isExpanded
    if isExpanded then
        toggleButton.Text = "[-]"
        mainFrame.Size = UDim2.new(0, 280, 0, 300)
        -- NEW: Reset the filter when opening
        searchBox.Text = ""
        updateFilter("") 
    else
        toggleButton.Text = "[+]"
        mainFrame.Size = UDim2.new(0, 280, 0, 30)
    end
end)

local function resetButtonColors()
    for _, button in pairs(langButtons) do
        button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    end
    stopButton.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
    jumbleButton.BackgroundColor3 = Color3.fromRGB(120, 60, 180)
end

-- This logic works perfectly with no changes, since we still
-- populated the 'langButtons' and 'languages' tables.
for langName, button in pairs(langButtons) do
    button.MouseButton1Click:Connect(function()
        resetButtonColors()
        button.BackgroundColor3 = Color3.fromRGB(70, 115, 190)
        isTranslatorActive = true
        isJumbleActive = false -- Deactivate Jumble mode.
        targetLanguage = languages[langName]
        sys("[TR] Translator enabled. Language set to " .. langName .. ".")
    end)
end

stopButton.MouseButton1Click:Connect(function()
    resetButtonColors()
    isTranslatorActive = false
    isJumbleActive = false -- Deactivate Jumble mode.
    targetLanguage = nil
    sys("[TR] Auto-translation DISABLED.")
end)

jumbleButton.MouseButton1Click:Connect(function()
    resetButtonColors()
    jumbleButton.BackgroundColor3 = Color3.fromRGB(160, 90, 220) -- Highlight color.
    isTranslatorActive = false
    isJumbleActive = true
    targetLanguage = nil
    sys("[TR] Jumble mode ENABLED. Have fun!")
end)

-- NEW: Connect the search box to the filter function
searchBox.Changed:Connect(function()
    updateFilter(searchBox.Text)
end)

--endregion

--region Main Logic
-- This section hooks into the chat system.

task.spawn(function()
	repeat task.wait() until CoreGui:FindFirstChild("ExperienceChat")
	local experienceChat = CoreGui:WaitForChild("ExperienceChat")
	local appLayout = experienceChat:WaitForChild("appLayout")
	local chatInputBar = appLayout:WaitForChild("chatInputBar")
	local background = chatInputBar:WaitForChild("Background")
	local container = background:WaitForChild("Container")
	local textContainer = container:WaitForChild("TextContainer")
	local textBoxContainer = textContainer:WaitForChild("TextBoxContainer")
	local textBox = textBoxContainer:WaitForChild("TextBox")
	local sendButton = container:WaitForChild("SendButton")

	local function onSend()
		local messageText = textBox.Text
		if messageText == "" then return end
		textBox.Text = ""
		-- The handleOutgoing function will decide if the message needs translation.
		if not handleOutgoing(messageText) then
			-- If not translated, send the original message.
			sendChat(messageText)
		end
	end

	textBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then onSend() end
	end)
	sendButton.MouseButton1Click:Connect(onSend)
end)

TCS.MessageReceived:Connect(function(msg)
	-- Don't translate your own messages or system messages.
	if not msg.TextSource or msg.TextSource.UserId == LP.UserId then return end
	local userId = msg.TextSource.UserId
	local player = Players:GetPlayerByUserId(userId)
	local displayName = player and player.DisplayName or tostring(userId)
	local userName = player and player.Name or tostring(userId)
	local nameString = (displayName == userName) and ("@" .. userName) or (displayName .. " (@" .. userName .. ")")
	
	-- Translate the incoming message into English.
	local text, detectedLang = translateInfo(msg.Text, yourLanguage, "auto")

	-- Display the translated message if the translation is different from the original.
	if text and text ~= "" and text ~= msg.Text then
		local langTag = detectedLang and detectedLang ~= "" and detectedLang:upper() or "AUTO"
		sys("(" .. langTag .. ") [" .. nameString .. "]: " .. text)
	end
end)

sys("[TR] Compact Translator UI loaded.")
sys("[TR] Click the [+] icon on the top-left bar to select a language.")

--MEME