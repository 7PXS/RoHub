local library = {}

local utility = {}

local obelus = {

	connections = {}

}



local uis = game:GetService("UserInputService")

local cre = game:GetService("CoreGui")



library.__index = library



do

	function utility:Create(createInfo)

		local createInfo = createInfo or {}



		if createInfo.Type then

			local instance = Instance.new(createInfo.Type)



			if createInfo.Properties and typeof(createInfo.Properties) == "table" then

				for property, value in pairs(createInfo.Properties) do

					instance[property] = value

				end

			end



			return instance

		end

	end



	function utility:Connection(connectionInfo)

		local connectionInfo = connectionInfo or {}



		if connectionInfo.Type then

			local connection = connectionInfo.Type:Connect(connectionInfo.Callback or function() end)



			obelus.connections[#obelus.connections] = connection



			return connection

		end

	end



	function utility:RemoveConnection(connectionInfo)

		local connectionInfo = connectionInfo or {}



		if connectionInfo.Connection then

			local found = table.find(obelus.connections, connectionInfo.Connection)



			if found then

				connectionInfo.Connection:Disconnect()



				table.remove(obelus.connections, found)

			end

		end

	end

end



do

	function library:Window(windowInfo)



		local info = windowInfo or {}

		local window = {Pages = {}, Dragging = false, Delta = UDim2.new(), Delta2 = Vector3.new()}



		local screen = utility:Create({Type = "ScreenGui", Properties = {

			Parent = cre,

			DisplayOrder = 8888,

			IgnoreGuiInset = true,

			Name = "obleus",

			ZIndexBehavior = "Global",

			ResetOnSpawn = false

		}})



        game:GetService("UserInputService").InputBegan:Connect(function(k,g)

            if not g then 

                if k.KeyCode == Enum.KeyCode.RightShift then 

                    screen.Enabled = not screen.Enabled 

                end

            end

        end)



		local main = utility:Create({Type = "Frame", Properties = {

			AnchorPoint = Vector2.new(0.5, 0.5),

			BackgroundColor3 = Color3.fromRGB(51, 51, 51),

			BorderColor3 = Color3.fromRGB(0, 0, 0),

			BorderMode = "Inset",

			BorderSizePixel = 1,

			Parent = screen,

			Position = UDim2.new(0.5, 0, 0.5, 0),

			Size = UDim2.new(0, 516, 0, 563)

		}})



		local frame = utility:Create({Type = "Frame", Properties = {

			AnchorPoint = Vector2.new(0.5, 0.5),

			BackgroundColor3 = Color3.fromRGB(12, 12, 12),

			BorderSizePixel = 0,

			Parent = main,

			Position = UDim2.new(0.5, 0, 0.5, 0),

			Size = UDim2.new(1, -2, 1, -2),

		}})



		local draggingButton = utility:Create({Type = "TextButton", Properties = {

			BackgroundTransparency = 1,

			BorderSizePixel = 0,

			Parent = frame,

			Position = UDim2.new(0, 0, 0, 0),

			Size = UDim2.new(1, 0, 0, 24),

			Text = ""

		}})



		local title = utility:Create({Type = "TextLabel", Properties = {

			BackgroundTransparency = 1,

			BorderSizePixel = 0,

			Parent = frame,

			Position = UDim2.new(0, 9, 0, 6),

			Size = UDim2.new(1, -16, 0, 15),

			Font = "Code",

			RichText = true,

			Text = info.Name or info.name or "obleus",

			TextColor3 = Color3.fromRGB(142, 142, 142),

			TextStrokeTransparency = 0.5,

			TextSize = 13,

			TextXAlignment = "Left"

		}})



		local accent = utility:Create({Type = "Frame", Properties = {

			BackgroundTransparency = 1,

			BorderSizePixel = 0,

			Parent = frame,

			Position = UDim2.new(0, 8, 0, 22),

			Size = UDim2.new(1, -16, 0, 2)

		}})



		local accentFirst = utility:Create({Type = "Frame", Properties = {

			BackgroundColor3 = Color3.fromRGB(170, 85, 235),

			BorderSizePixel = 0,

			Parent = accent,

			Position = UDim2.new(0, 0, 0, 0),

			Size = UDim2.new(1, 0, 0, 1)

		}})



		local accentSecond = utility:Create({Type = "Frame", Properties = {

			BackgroundColor3 = Color3.fromRGB(101, 51, 141),

			BorderSizePixel = 0,

			Parent = accent,

			Position = UDim2.new(0, 0, 0, 1),

			Size = UDim2.new(1, 0, 0, 1)

		}})



		local tabs = utility:Create({Type = "Frame", Properties = {

			BackgroundColor3 = Color3.fromRGB(1, 1, 1),

			BorderSizePixel = 0,

			Parent = frame,

			Position = UDim2.new(0, 8, 0, 29),

			Size = UDim2.new(1, -16, 0, 30)

		}})



		local tabsInline = utility:Create({Type = "Frame", Properties = {

			BackgroundColor3 = Color3.fromRGB(1, 1, 1),

			BorderSizePixel = 0,

			Parent = tabs,

			Position = UDim2.new(0, 0, 0, 0),

			Size = UDim2.new(1, -1, 1, 0)

		}})



		utility:Create({Type = "UIListLayout", Properties = {

			Padding = UDim.new(0, 0),

			Parent = tabsInline,

			FillDirection = "Horizontal"

		}})



		local pagesHolder = utility:Create({Type = "Frame", Properties = {

			BackgroundColor3 = Color3.fromRGB(51, 51, 51),

			BorderColor3 = Color3.fromRGB(0, 0, 0),

			BorderMode = "Inset",

			BorderSizePixel = 1,

			Parent = frame,

			Position = UDim2.new(0, 8, 0, 65),

			Size = UDim2.new(1, -16, 1, -76)

		}})



		local pagesFrame = utility:Create({Type = "Frame", Properties = {

			BackgroundColor3 = Color3.fromRGB(13, 13, 13),

			BorderSizePixel = 0,

			Parent = pagesHolder,

			Position = UDim2.new(0, 1, 0, 1),

			Size = UDim2.new(1, -2, 1, -2)

		}})



		local pagesFolder = utility:Create({Type = "Folder", Properties = {

			Parent = pagesFrame

		}})



		local connection = utility:Connection({Type = draggingButton.InputBegan, Callback = function(Input)

			if not window.Dragging and Input.UserInputType == Enum.UserInputType.MouseButton1 then

				window.Dragging = true

				window.Delta = main.Position

				window.Delta2 = Input.Position

			end

		end})



		local connection2 = utility:Connection({Type = uis.InputEnded, Callback = function(Input)

			if window.Dragging and Input.UserInputType == Enum.UserInputType.MouseButton1 then

				window.Dragging = false

				window.Delta = UDim2.new()

				window.Delta2 = Vector3.new()

			end

		end})



		local connection3 = utility:Connection({Type = uis.InputChanged, Callback = function(Input)

			if window.Dragging then

				local Delta = Input.Position - window.Delta2

				main.Position = UDim2.new(window.Delta.X.Scale, window.Delta.X.Offset + Delta.X, window.Delta.Y.Scale, window.Delta.Y.Offset + Delta.Y)

			end

		end})



		function window:RefreshTabs()

			for index, page in pairs(window.Pages) do

				page.Tab.Size = UDim2.new(1 / (#window.Pages), 0, 1, 0)

			end

		end



		function window:Page(pageInfo)



			local info = pageInfo or {}

			local page = {Open = false}



			local tab = utility:Create({Type = "Frame", Properties = {

				BackgroundTransparency = 1,

				BorderSizePixel = 0,

				Parent = tabsInline,

				Size = UDim2.new(1, 0, 1, 0)

			}})



			local tabButton = utility:Create({Type = "TextButton", Properties = {

				BackgroundTransparency = 1,

				BorderSizePixel = 0,

				Parent = tab,

				Position = UDim2.new(0, 0, 0, 0),

				Size = UDim2.new(1, 0, 1, 0)

			}})



			local tabInline = utility:Create({Type = "Frame", Properties = {

				BackgroundColor3 = Color3.fromRGB(41, 41, 41),

				BorderSizePixel = 0,

				Parent = tab,

				Position = UDim2.new(0, 1, 0, 1),

				Size = UDim2.new(1, -1, 1, -2)

			}})



			local tabInlineGradient = utility:Create({Type = "Frame", Properties = {

				BackgroundColor3 = Color3.fromRGB(41, 41, 41),

				BorderSizePixel = 0,

				Parent = tabInline,

				Position = UDim2.new(0, 1, 0, 1),

				Size = UDim2.new(1, -2, 1, -2)

			}})



			local tabGradient = utility:Create({Type = "UIGradient", Properties = {

				Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100))}),

				Rotation = 90,

				Parent = tabInlineGradient

			}})



			local tabTitle = utility:Create({Type = "TextLabel", Properties = {

				AnchorPoint = Vector2.new(0, 0.5),

				BackgroundTransparency = 1,

				BorderSizePixel = 0,

				Parent = tabInlineGradient,

				Position = UDim2.new(0, 4, 0.5, 0),

				Size = UDim2.new(1, -8, 0, 15),

				Font = "Code",

				RichText = true,

				Text = info.Name or info.name or "tab",

				TextColor3 = Color3.fromRGB(142, 142, 142),

				TextStrokeTransparency = 0.5,

				TextSize = 13,

				TextXAlignment = "Center"

			}})



			local pageHolder = utility:Create({Type = "Frame", Properties = {

				BackgroundTransparency = 1,

				BorderSizePixel = 0,

				Parent = pagesFolder,

				Position = UDim2.new(0, 10, 0, 10),

				Size = UDim2.new(1, -20, 1, -20),

				Visible = false

			}})



			local leftHolder = utility:Create({Type = "Frame", Properties = {

				BackgroundTransparency = 1,

				BorderSizePixel = 0,

				Parent = pageHolder,

				Position = UDim2.new(0, 0, 0 ,0),

				Size = UDim2.new(0.5, -5, 1, 0)

			}})



			local rightHolder = utility:Create({Type = "Frame", Properties = {

				AnchorPoint = Vector2.new(1, 0),

				BackgroundTransparency = 1,

				BorderSizePixel = 0,

				Parent = pageHolder,

				Position = UDim2.new(1, 0, 0 ,0),

				Size = UDim2.new(0.5, -5, 1, 0)

			}})



			utility:Connection({Type = tabButton.MouseButton1Down, Callback = function()

				if not page.open then

					for index, other_page in pairs(window.Pages) do

						if other_page ~= page then

							other_page:Turn(false)

						end

					end

				end



				page:Turn(true)

			end})



			function page:Turn(state)

				tabTitle.TextColor3 = state and Color3.fromRGB(170, 85, 235) or Color3.fromRGB(142, 142, 142)

				tabGradient.Color = state and ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(155, 155, 155))}) or ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100))})



				page.PageHolder.Visible = state

				page.Open = state

			end



			function page:Section(sectionInfo)



				local info = sectionInfo or {}

				local section = {}



				local sectionMain = utility:Create({Type = "Frame", Properties = {

					BackgroundColor3 = Color3.fromRGB(45, 45, 45),

					BorderColor3 = Color3.fromRGB(13, 13, 13),

					BorderMode = "Inset",

					BorderSizePixel = 1,

					Parent = page[((info.Side and info.Side:lower() == "right") or (info.side and info.side:lower() == "right")) and "Right" or "Left"],

					Position = UDim2.new(0, 0, 0, 0),

					Size = UDim2.new(1, 0, 0, (info.Size or info.size or 200) + 4)

				}})



				local sectionFrame = utility:Create({Type = "Frame", Properties = {

					BackgroundColor3 = Color3.fromRGB(19, 19, 19),

					BorderSizePixel = 0,

					Parent = sectionMain,

					Position = UDim2.new(0, 1, 0, 1),

					Size = UDim2.new(1, -2, 1, -2)

				}})



				local sectionTitle = utility:Create({Type = "TextLabel", Properties = {

					AnchorPoint = Vector2.new(0, 0.5),

					BackgroundTransparency = 1,

					BorderSizePixel = 0,

					Parent = sectionMain,

					Position = UDim2.new(0, 13, 0, 0),

					Size = UDim2.new(1, -26, 0, 15),

					Font = "Code",

					RichText = true,

					Text = info.Name or info.name or "new section",

					TextColor3 = Color3.fromRGB(205, 205, 205),

					TextStrokeTransparency = 0.5,

					TextSize = 13,

					TextXAlignment = "Left",

					ZIndex = 2

				}})



				local sectionTitleLine = utility:Create({Type = "Frame", Properties = {

					BackgroundColor3 = Color3.fromRGB(19, 19, 19),

					BorderSizePixel = 0,

					Parent = sectionMain,

					Position = UDim2.new(0, 9, 0, 0),

					Size = UDim2.new(0, sectionTitle.TextBounds.X + 6, 0, 1)

				}})



				local sectionScrolling = utility:Create({Type = "Frame", Properties = {

					BackgroundTransparency = 1,

					BorderSizePixel = 0,

					Parent = sectionMain,

					Position = UDim2.new(0, 1, 0, 1),

					Size = UDim2.new(1, -2, 1, -2),

					Visible = false

				}})



				local sectionScrollingBar = utility:Create({Type = "Frame", Properties = {

					AnchorPoint = Vector2.new(1, 0),

					BackgroundColor3 = Color3.fromRGB(45, 45, 45),

					BorderSizePixel = 0,

					Parent = sectionScrolling,

					Position = UDim2.new(1, 0, 0, 0),

					Size = UDim2.new(0, 5, 1, 0),

					ZIndex = 3

				}})



				local sectionScrollingGradient = utility:Create({Type = "ImageLabel", Properties = {

					AnchorPoint = Vector2.new(0, 1),

					BackgroundTransparency = 1,

					BorderSizePixel = 0,

					Parent = sectionScrolling,

					Position = UDim2.new(0, 0, 1, 0),

					Size = UDim2.new(1, 0, 0, 20),

					ZIndex = 2,

					Image = "rbxassetid://7783533907",

					ImageTransparency = 0,

					ImageColor3 = Color3.fromRGB(19, 19, 19),

					ScaleType = "Stretch"

				}})



				local sectionContentHolder = utility:Create({Type = "ScrollingFrame", Properties = {

					BackgroundTransparency = 1,

					BorderSizePixel = 0,

					Parent = sectionFrame,

					Position = UDim2.new(0, 0, 0, 0),

					Size = UDim2.new(1, 0, 1, 0),

					ZIndex = 4,

					AutomaticCanvasSize = "Y",

					BottomImage = "rbxassetid://7783554086",

					CanvasSize = UDim2.new(0, 0, 0, 0),

					MidImage = "rbxassetid://7783554086",

					ScrollBarImageColor3 = Color3.fromRGB(65, 65, 65),

					ScrollBarThickness = 4,

					TopImage = "rbxassetid://7783554086",

					VerticalScrollBarInset = "ScrollBar"

				}})



				utility:Create({Type = "UIListLayout", Properties = {

					Padding = UDim.new(0, 5),

					Parent = sectionContentHolder,

					FillDirection = "Vertical"

				}})



				local sectionInline = utility:Create({Type = "Frame", Properties = {

					BackgroundColor3 = Color3.fromRGB(19, 19, 19),

					BorderSizePixel = 0,

					Parent = sectionContentHolder,

					Position = UDim2.new(0, 1, 0, 1),

					Size = UDim2.new(1, 0, 0, 10)

				}})



				function section:Update()

					if sectionContentHolder.AbsoluteCanvasSize.Y > ((info.Size or info.size or 200) + 4) then

						sectionScrolling.Visible = true

					else

						sectionScrolling.Visible = false

					end

				end



				function section:Label(labelInfo)



					local info = labelInfo or {}

					local label = {}



					local contentHolder = utility:Create({Type = "Frame", Properties = {

						BackgroundTransparency = 1,

						BorderSizePixel = 0,

						Parent = sectionContentHolder,

						Size = UDim2.new(1, 0, 0, 14)

					}})



					local labelTitle = utility:Create({Type = "TextLabel", Properties = {

						AnchorPoint = Vector2.new(0, 0),

						BackgroundTransparency = 1,

						BorderSizePixel = 0,

						Parent = contentHolder,

						Size = UDim2.new(1, -(info.Offset or 36), 1, 0),

						Position = UDim2.new(0, info.Offset or 36, 0, 0),

						Font = "Code",

						RichText = true,

						Text = info.Name or info.name or info.Text or info.text or "new label",

						TextColor3 = Color3.fromRGB(180, 180, 180),

						TextStrokeTransparency = 0.5,

						TextSize = 13,

						TextXAlignment = "Left"

					}})



					function label:Remove()

						contentHolder:Remove()

						label = nil



						section:Update()

					end



					section:Update()



					return label

				end



				function section:Toggle(toggleInfo)



					local info = toggleInfo or {}

					local toggle = {

						state = (info.Default or info.default or info.Def or info.def or false),

						callback = (info.Callback or info.callback or function() end)

					}



					local contentHolder = utility:Create({Type = "Frame", Properties = {

						BackgroundTransparency = 1,

						BorderSizePixel = 0,

						Parent = sectionContentHolder,

						Size = UDim2.new(1, 0, 0, 14)

					}})



					local toggleButton = utility:Create({Type = "TextButton", Properties = {

						BackgroundTransparency = 1,

						BorderSizePixel = 0,

						Parent = contentHolder,

						Position = UDim2.new(0, 0, 0, 0),

						Size = UDim2.new(1, 0, 1, 0),

						Text = ""

					}})



					local toggleTitle = utility:Create({Type = "TextLabel", Properties = {

						AnchorPoint = Vector2.new(0, 0),

						BackgroundTransparency = 1,

						BorderSizePixel = 0,

						Parent = contentHolder,

						Size = UDim2.new(1, -36, 1, 0),

						Position = UDim2.new(0, 36, 0, 0),

						Font = "Code",

						RichText = true,

						Text = info.Name or info.name or info.Text or info.text or "new toggle",

						TextColor3 = Color3.fromRGB(180, 180, 180),

						TextStrokeTransparency = 0.5,

						TextSize = 13,

						TextXAlignment = "Left"

					}})



					local toggleFrame = utility:Create({Type = "Frame", Properties = {

						BackgroundColor3 = Color3.fromRGB(1, 1, 1),

						BorderSizePixel = 0,

						Parent = contentHolder,

						Position = UDim2.new(0, 16, 0, 2),

						Size = UDim2.new(0, 10, 0, 10)

					}})



					local toggleInlineGradient = utility:Create({Type = "Frame", Properties = {

						BackgroundColor3 = toggle.state and Color3.fromRGB(170, 85, 235) or Color3.fromRGB(63, 63, 63),

						BorderSizePixel = 0,

						Parent = toggleFrame,

						Position = UDim2.new(0, 1, 0, 1),

						Size = UDim2.new(1, -2, 1, -2)

					}})



					local toggleGradient = utility:Create({Type = "UIGradient", Properties = {

						Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(125, 125, 125))}),

						Rotation = 90,

						Parent = toggleInlineGradient

					}})



					local connection = utility:Connection({Type = toggleButton.MouseButton1Down, Callback = function()

						toggle.state = not toggle.state

						toggleInlineGradient.BackgroundColor3 = toggle.state and Color3.fromRGB(170, 85, 235) or Color3.fromRGB(63, 63, 63)

						toggle.callback(toggle.state)

					end})



					function toggle:Remove()

						contentHolder:Remove()

						toggle = nil



						utility:RemoveConnection({Connection = connection})

						connection = nil



						section:Update()

					end



					function toggle:Get()

						return toggle.state

					end



					function toggle:Set(value)

						if typeof(value) == "boolean" then

							toggle.state = value

						end

					end



					section:Update()



					return toggle

				end



				function section:Button(buttonInfo)



					local info = buttonInfo or {}

					local button = {

						callback = (info.Callback or info.callback or function() end)

					}



					local contentHolder = utility:Create({Type = "Frame", Properties = {

						BackgroundTransparency = 1,

						BorderSizePixel = 0,

						Parent = sectionContentHolder,

						Size = UDim2.new(1, 0, 0, 20)

					}})



					local buttonButton = utility:Create({Type = "TextButton", Properties = {

						BackgroundTransparency = 1,

						BorderSizePixel = 0,

						Parent = contentHolder,

						Position = UDim2.new(0, 0, 0, 0),

						Size = UDim2.new(1, 0, 1, 0),

						Text = ""

					}})



					local buttonFrame = utility:Create({Type = "Frame", Properties = {

						BackgroundColor3 = Color3.fromRGB(45, 45, 45),

						BorderColor3 = Color3.fromRGB(1, 1, 1),

						BorderMode = "Inset",

						BorderSizePixel = 1,

						Parent = contentHolder,

						Position = UDim2.new(0, 16, 0, 0),

						Size = UDim2.new(1, -32, 1, 0)

					}})



					local buttonInline = utility:Create({Type = "Frame", Properties = {

						BackgroundColor3 = Color3.fromRGB(25, 25, 25),

						BorderSizePixel = 0,

						Parent = buttonFrame,

						Position = UDim2.new(0, 1, 0, 1),

						Size = UDim2.new(1, -2, 1, -2)

					}})



					local buttonTitle = utility:Create({Type = "TextLabel", Properties = {

						BackgroundTransparency = 1,

						BorderSizePixel = 0,

						Parent = contentHolder,

						Size = UDim2.new(1, -32, 1, 0),

						Position = UDim2.new(0, 16, 0, 0),

						Font = "Code",

						RichText = true,

						Text = info.Name or info.name or info.Text or info.text or "new button",

						TextColor3 = Color3.fromRGB(180, 180, 180),

						TextStrokeTransparency = 0.5,

						TextSize = 13,

						TextXAlignment = "Center"

					}})



					local connection = utility:Connection({Type = buttonButton.MouseButton1Down, Callback = function()

						button.callback()

					end})



					function button:Remove()

						contentHolder:Remove()

						button = nil



						utility:RemoveConnection({Connection = connection})

						connection = nil



						section:Update()

					end



					section:Update()



					return button

				end



				function section:Slider(sliderInfo)



					local info = sliderInfo or {}

					local slider = {

						state = (info.Default or info.default or info.Def or info.def or 0),

						min = (info.Minimum or info.minimum or info.Min or info.min or 0),

						max = (info.Maximum or info.maximum or info.Max or info.max or 10),

						decimals = (1 / (info.Decimals or info.decimals or info.Tick or info.tick or 0.25)),

						suffix = (info.Suffix or info.suffix or info.Ending or info.ending or ""),

						callback = (info.Callback or info.callback or function() end),

						holding = false

					}



					local contentHolder = utility:Create({Type = "Frame", Properties = {

						BackgroundTransparency = 1,

						BorderSizePixel = 0,

						Parent = sectionContentHolder,

						Size = UDim2.new(1, 0, 0, (info.Name or info.name or info.Text or info.text) and 24 or 10)

					}})



					local sliderButton = utility:Create({Type = "TextButton", Properties = {

						BackgroundTransparency = 1,

						BorderSizePixel = 0,

						Parent = contentHolder,

						Position = UDim2.new(0, 0, 0, 0),

						Size = UDim2.new(1, 0, 1, 0),

						Text = ""

					}})



					if (info.Name or info.name or info.Text or info.text) then

						local sliderTitle = utility:Create({Type = "TextLabel", Properties = {

							AnchorPoint = Vector2.new(0, 0),

							BackgroundTransparency = 1,

							BorderSizePixel = 0,

							Parent = contentHolder,

							Size = UDim2.new(1, -16, 0, 14),

							Position = UDim2.new(0, 16, 0, 0),

							Font = "Code",

							RichText = true,

							Text = (info.Name or info.name or info.Text or info.text),

							TextColor3 = Color3.fromRGB(180, 180, 180),

							TextStrokeTransparency = 0.5,

							TextSize = 13,

							TextXAlignment = "Left"

						}})

					end



					local sliderFrame = utility:Create({Type = "Frame", Properties = {

						BackgroundColor3 = Color3.fromRGB(1, 1, 1),

						BorderSizePixel = 0,

						Parent = contentHolder,

						Position = UDim2.new(0, 16, 0, (info.Name or info.name or info.Text or info.text) and 14 or 0),

						Size = UDim2.new(1, -32, 0, 10)

					}})



					local sliderInlineGradient = utility:Create({Type = "Frame", Properties = {

						BackgroundColor3 = Color3.fromRGB(63, 63, 63),

						BorderSizePixel = 0,

						Parent = sliderFrame,

						Position = UDim2.new(0, 1, 0, 1),

						Size = UDim2.new(1, -2, 1, -2)

					}})



					local sliderGradient = utility:Create({Type = "UIGradient", Properties = {

						Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(125, 125, 125))}),

						Rotation = 90,

						Parent = sliderInlineGradient

					}})



					local sliderSlideHolder = utility:Create({Type = "Frame", Properties = {

						BackgroundTransparency = 1,

						BorderSizePixel = 0,

						Parent = sliderFrame,

						Position = UDim2.new(0, 1, 0, 1),

						Size = UDim2.new(1, -2, 1, -2)

					}})



					local sliderSlide = utility:Create({Type = "Frame", Properties = {

						BackgroundColor3 = Color3.fromRGB(170, 85, 235),

						BorderSizePixel = 0,

						Parent = sliderSlideHolder,

						Position = UDim2.new(0, 0, 0, 0),

						Size = UDim2.new(0.5, 0, 1, 0)

					}})



					local sliderGradient = utility:Create({Type = "UIGradient", Properties = {

						Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(125, 125, 125))}),

						Rotation = 90,

						Parent = sliderSlide

					}})



					local sliderValue = utility:Create({Type = "TextLabel", Properties = {

						AnchorPoint = Vector2.new(0.5, 0.25),

						BackgroundTransparency = 1,

						BorderSizePixel = 0,

						Parent = sliderSlide,

						Size = UDim2.new(0, 10, 0, 14),

						Position = UDim2.new(1, 0, 0.5, 0),

						Font = "Code",

						RichText = true,

						Text = tostring(slider.state) .. tostring(slider.suffix),

						TextColor3 = Color3.fromRGB(180, 180, 180),

						TextStrokeTransparency = 0.5,

						TextSize = 13,

						TextXAlignment = "Left"

					}})



					local connection = utility:Connection({Type = sliderButton.MouseButton1Down, Callback = function()

						slider.holding = true

						slider:Refresh()

					end})



					local connection2 = utility:Connection({Type = uis.InputEnded, Callback = function()

						slider.holding = false

					end})



					local connection3 = utility:Connection({Type = uis.InputChanged, Callback = function()

						if slider.holding then

							slider:Refresh()

						end

					end})



					function slider:Remove()

						contentHolder:Remove()

						slider = nil



						utility:RemoveConnection({Connection = connection})

						connection = nil

						utility:RemoveConnection({Connection = connection2})

						connection2 = nil

						utility:RemoveConnection({Connection = connection3})

						connection3 = nil



						section:Update()

					end



					function slider:Get()

						return slider.state

					end



					function slider:Set(value)

						slider.state = math.clamp(math.round(value * slider.decimals) / slider.decimals, slider.min, slider.max)

						sliderSlide.Size = UDim2.new(1 - ((slider.max - slider.state) / (slider.max - slider.min)), 0, 1, 0)

						sliderValue.Text = tostring(slider.state) .. tostring(slider.suffix)

						pcall(slider.callback, slider.state)

					end



					function slider:Refresh()

						if slider.holding then

							local mouseLocation = uis:GetMouseLocation()

							slider:Set(math.clamp(math.floor((slider.min + (slider.max - slider.min) * (math.clamp(mouseLocation.X - sliderSlide.AbsolutePosition.X, 0, sliderSlideHolder.AbsoluteSize.X) / sliderSlideHolder.AbsoluteSize.X)) * slider.decimals) / slider.decimals, slider.min, slider.max))

						end

					end



					section:Update()

					slider:Set(slider.state)



					return slider

				end



				return section

			end



			page.Tab = tab

			page.PageHolder = pageHolder

			page.Left = leftHolder

			page.Right = rightHolder



			window.Pages[#window.Pages + 1] = page

			window:RefreshTabs()



			return page

		end



		return window

	end

end



local ESP = {

    Enabled = true,

    Players = {

        Enabled = false,

        MaxDistance = 1000,

        ShowDistance = false,

        ShowHealth = false,

        IgnoreTeammates = false,

        EnemyColor = Color3.fromRGB(255, 0, 0),

        TextSize = 13,

        TextColor = Color3.new(0.117647, 1.000000, 0.000000),

        OutlineColor = Color3.fromRGB(0, 0, 0),

        Tracers = false,

        ShowName = true,

        ShowWeapon = false,

        ShowRace = false

    },

    NPCs = {

        Enabled = false,

        MaxDistance = 1000,

        ShowDistance = false,

        ShowHealth = false,

        TextSize = 13,

        TextColor = Color3.new(1, 0.65, 0),

        OutlineColor = Color3.fromRGB(0, 0, 0),

        Tracers = false,

        ShowName = true,

        ShowWeapon = false,

        ShowRace = false

    },

    LootBoxes = {

        Enabled = false,

        MaxDistance = 1000,

        ShowDistance = false,

        TextSize = 13,

        TextColor = Color3.new(1, 0.84, 0),

        OutlineColor = Color3.fromRGB(0, 0, 0),

        Tracers = false,

        ShowName = true

    },

    LootBags = {

        Enabled = false,

        MaxDistance = 1000,

        ShowDistance = false,

        TextSize = 13,

        TextColor = Color3.new(0.29, 0, 0.51),

        OutlineColor = Color3.fromRGB(0, 0, 0),

        Tracers = false,

        ShowName = true

    },

    RefreshRate = 0

}



local cache = {

    drawings = {},

    espData = {}

}



local function updateESP()



    warn("ESP settings updated")



end



local window = library:Window({name = "<font color=\"#AA55EB\">RoHub</font> | <font color=\"#FF0000\">GHOUL://RE</font>"})



local combatTab = window:Page({Name = "Combat"})

local visualsTab = window:Page({Name = "Visuals"})

local playerTab = window:Page({Name = "Player"})

local autoFarmTab = window:Page({Name = "AutoFarm"})

local raidsTab = window:Page({Name = "Raids"})



local combatSection = combatTab:Section({Name = "Combat Settings", size = 400})

local saveHPSection = combatTab:Section({Name = "Health Settings", size = 400, Side = "Right"})



combatSection:Toggle({Name = "Auto Parry", Default = false, Callback = function(val) warn("Auto Parry: " .. tostring(val)) end})

combatSection:Toggle({Name = "No Stun", Default = false, Callback = function(val) warn("No Stun: " .. tostring(val)) end})

combatSection:Toggle({Name = "AP Breaker", Default = false, Callback = function(val) warn("AP Breaker: " .. tostring(val)) end})

saveHPSection:Slider({Name = "Save HP Threshold", Default = 30, Minimum = 0, Maximum = 100, Decimals = 0, Suffix = "%", Callback = function(val) warn("Save HP Threshold: " .. val) end})

saveHPSection:Toggle({Name = "PermaDeath GodMode", Default = false, Callback = function(val) warn("PermaDeath GodMode: " .. tostring(val)) end})



local playerVisualsSection = visualsTab:Section({Name = "Player & NPC ESP", size = 400})

local lootVisualsSection = visualsTab:Section({Name = "Loot ESP & Settings", size = 400, Side = "Right"})



playerVisualsSection:Toggle({Name = "Master ESP Toggle", Default = ESP.Enabled, Callback = function(val) 

    ESP.Enabled = val

    updateESP()

    warn("Master ESP Toggle: " .. tostring(val))

end})



playerVisualsSection:Label({Name = "Player ESP Settings", Offset = 5})

playerVisualsSection:Toggle({Name = "Player ESP", Default = ESP.Players.Enabled, Callback = function(val) 

    ESP.Players.Enabled = val

    updateESP()

    warn("Player ESP: " .. tostring(val))

end})

playerVisualsSection:Toggle({Name = "Tracers", Default = ESP.Players.Tracers, Callback = function(val) 

    ESP.Players.Tracers = val

    updateESP()

    warn("Player Tracers: " .. tostring(val))

end})

playerVisualsSection:Toggle({Name = "Health", Default = ESP.Players.ShowHealth, Callback = function(val) 

    ESP.Players.ShowHealth = val

    updateESP()

    warn("Player Health: " .. tostring(val))

end})

playerVisualsSection:Toggle({Name = "Name", Default = ESP.Players.ShowName, Callback = function(val) 

    ESP.Players.ShowName = val

    updateESP()

    warn("Player Name: " .. tostring(val))

end})

playerVisualsSection:Toggle({Name = "Weapon", Default = ESP.Players.ShowWeapon, Callback = function(val) 

    ESP.Players.ShowWeapon = val

    updateESP()

    warn("Player Weapon: " .. tostring(val))

end})

playerVisualsSection:Toggle({Name = "Distance", Default = ESP.Players.ShowDistance, Callback = function(val) 

    ESP.Players.ShowDistance = val

    updateESP()

    warn("Player Distance: " .. tostring(val))

end})

playerVisualsSection:Toggle({Name = "Race", Default = ESP.Players.ShowRace, Callback = function(val) 

    ESP.Players.ShowRace = val

    updateESP()

    warn("Player Race: " .. tostring(val))

end})

playerVisualsSection:Slider({Name = "Player ESP Distance", Default = ESP.Players.MaxDistance, Minimum = 100, Maximum = 2000, Decimals = 0, Suffix = "m", Callback = function(val) 

    ESP.Players.MaxDistance = val

    updateESP()

    warn("Player ESP Distance: " .. val)

end})



playerVisualsSection:Label({Name = "NPC ESP Settings", Offset = 10})

playerVisualsSection:Toggle({Name = "NPC ESP", Default = ESP.NPCs.Enabled, Callback = function(val) 

    ESP.NPCs.Enabled = val

    updateESP()

    warn("NPC ESP: " .. tostring(val))

end})

playerVisualsSection:Toggle({Name = "Tracers", Default = ESP.NPCs.Tracers, Callback = function(val) 

    ESP.NPCs.Tracers = val

    updateESP()

    warn("NPC Tracers: " .. tostring(val))

end})

playerVisualsSection:Toggle({Name = "Health", Default = ESP.NPCs.ShowHealth, Callback = function(val) 

    ESP.NPCs.ShowHealth = val

    updateESP()

    warn("NPC Health: " .. tostring(val))

end})

playerVisualsSection:Toggle({Name = "Name", Default = ESP.NPCs.ShowName, Callback = function(val) 

    ESP.NPCs.ShowName = val

    updateESP()

    warn("NPC Name: " .. tostring(val))

end})

playerVisualsSection:Toggle({Name = "Weapon", Default = ESP.NPCs.ShowWeapon, Callback = function(val) 

    ESP.NPCs.ShowWeapon = val

    updateESP()

    warn("NPC Weapon: " .. tostring(val))

end})

playerVisualsSection:Toggle({Name = "Distance", Default = ESP.NPCs.ShowDistance, Callback = function(val) 

    ESP.NPCs.ShowDistance = val

    updateESP()

    warn("NPC Distance: " .. tostring(val))

end})

playerVisualsSection:Toggle({Name = "Race", Default = ESP.NPCs.ShowRace, Callback = function(val) 

    ESP.NPCs.ShowRace = val

    updateESP()

    warn("NPC Race: " .. tostring(val))

end})

playerVisualsSection:Slider({Name = "NPC ESP Distance", Default = ESP.NPCs.MaxDistance, Minimum = 100, Maximum = 2000, Decimals = 0, Suffix = "m", Callback = function(val) 

    ESP.NPCs.MaxDistance = val

    updateESP()

    warn("NPC ESP Distance: " .. val)

end})



lootVisualsSection:Label({Name = "LootBox ESP Settings", Offset = 5})

lootVisualsSection:Toggle({Name = "LootBox ESP", Default = ESP.LootBoxes.Enabled, Callback = function(val) 

    ESP.LootBoxes.Enabled = val

    updateESP()

    warn("LootBox ESP: " .. tostring(val))

end})

lootVisualsSection:Toggle({Name = "Tracers", Default = ESP.LootBoxes.Tracers, Callback = function(val) 

    ESP.LootBoxes.Tracers = val

    updateESP()

    warn("LootBox Tracers: " .. tostring(val))

end})

lootVisualsSection:Toggle({Name = "Name", Default = ESP.LootBoxes.ShowName, Callback = function(val) 

    ESP.LootBoxes.ShowName = val

    updateESP()

    warn("LootBox Name: " .. tostring(val))

end})

lootVisualsSection:Toggle({Name = "Distance", Default = ESP.LootBoxes.ShowDistance, Callback = function(val) 

    ESP.LootBoxes.ShowDistance = val

    updateESP()

    warn("LootBox Distance: " .. tostring(val))

end})

lootVisualsSection:Slider({Name = "LootBox ESP Distance", Default = ESP.LootBoxes.MaxDistance, Minimum = 100, Maximum = 2000, Decimals = 0, Suffix = "m", Callback = function(val) 

    ESP.LootBoxes.MaxDistance = val

    updateESP()

    warn("LootBox ESP Distance: " .. val)

end})



lootVisualsSection:Label({Name = "LootBag ESP Settings", Offset = 10})

lootVisualsSection:Toggle({Name = "LootBag ESP", Default = ESP.LootBags.Enabled, Callback = function(val) 

    ESP.LootBags.Enabled = val

    updateESP()

    warn("LootBag ESP: " .. tostring(val))

end})

lootVisualsSection:Toggle({Name = "Tracers", Default = ESP.LootBags.Tracers, Callback = function(val) 

    ESP.LootBags.Tracers = val

    updateESP()

    warn("LootBag Tracers: " .. tostring(val))

end})

lootVisualsSection:Toggle({Name = "Name", Default = ESP.LootBags.ShowName, Callback = function(val) 

    ESP.LootBags.ShowName = val

    updateESP()

    warn("LootBag Name: " .. tostring(val))

end})

lootVisualsSection:Toggle({Name = "Distance", Default = ESP.LootBags.ShowDistance, Callback = function(val) 

    ESP.LootBags.ShowDistance = val

    updateESP()

    warn("LootBag Distance: " .. tostring(val))

end})

lootVisualsSection:Slider({Name = "LootBag ESP Distance", Default = ESP.LootBags.MaxDistance, Minimum = 100, Maximum = 2000, Decimals = 0, Suffix = "m", Callback = function(val) 

    ESP.LootBags.MaxDistance = val

    updateESP()

    warn("LootBag ESP Distance: " .. val)

end})



lootVisualsSection:Label({Name = "Visual Settings", Offset = 10})

lootVisualsSection:Slider({Name = "ESP Refresh Rate", Default = ESP.RefreshRate, Minimum = 0, Maximum = 30, Decimals = 0, Suffix = " fps", Callback = function(val) 

    ESP.RefreshRate = val

    updateESP()

    warn("ESP Refresh Rate: " .. val)

end})

lootVisualsSection:Button({Name = "Reset Colors", Callback = function() 

    ESP.Players.TextColor = Color3.new(0.117647, 1.000000, 0.000000)

    ESP.Players.OutlineColor = Color3.fromRGB(0, 0, 0)

    ESP.NPCs.TextColor = Color3.new(1, 0.65, 0)

    ESP.NPCs.OutlineColor = Color3.fromRGB(0, 0, 0)

    ESP.LootBoxes.TextColor = Color3.new(1, 0.84, 0)

    ESP.LootBoxes.OutlineColor = Color3.fromRGB(0, 0, 0)

    ESP.LootBags.TextColor = Color3.new(0.29, 0, 0.51)

    ESP.LootBags.OutlineColor = Color3.fromRGB(0, 0, 0)

    updateESP()

    warn("Reset Colors")

end})



local movementSection = playerTab:Section({Name = "Movement", size = 400})

local extraSection = playerTab:Section({Name = "Extra Settings", size = 400, Side = "Right"})



local flyEnabled = false

local walkSpeed = 16

local jumpPower = 50

local flySpeed = 16



movementSection:Toggle({Name = "Fly (Keybind: X)", Default = flyEnabled, Callback = function(val) 

    flyEnabled = val



    warn("Fly: " .. tostring(val))

end})

movementSection:Slider({Name = "Fly Speed", Default = flySpeed, Minimum = 1, Maximum = 100, Decimals = 0, Suffix = " studs/s", Callback = function(val) 

    flySpeed = val



    warn("Fly Speed: " .. val)

end})

movementSection:Slider({Name = "Walk Speed", Default = walkSpeed, Minimum = 1, Maximum = 100, Decimals = 0, Suffix = " studs/s", Callback = function(val) 

    walkSpeed = val



    warn("Walk Speed: " .. val)

end})

movementSection:Slider({Name = "Jump Power", Default = jumpPower, Minimum = 1, Maximum = 200, Decimals = 0, Suffix = " studs", Callback = function(val) 

    jumpPower = val



    warn("Jump Power: " .. val)

end})



local killAuraSection = autoFarmTab:Section({Name = "Kill Aura & Farm", size = 400})

local missionSection = autoFarmTab:Section({Name = "Missions & Looting", size = 400, Side = "Right"})



local killAuraEnabled = false

local killAuraRange = 10

local targetHealthPercent = 100

local freezeMobsEnabled = false

local freezeRange = 15

local autoFarmEnabled = false

local farmDistance = 5

local positionRelative = "Behind"

local autoGripEnabled = false



killAuraSection:Toggle({Name = "Kill Aura", Default = killAuraEnabled, Callback = function(val) 

    killAuraEnabled = val

    warn("Kill Aura: " .. tostring(val))

end})

killAuraSection:Slider({Name = "Kill Aura Range", Default = killAuraRange, Minimum = 1, Maximum = 50, Decimals = 1, Suffix = " studs", Callback = function(val) 

    killAuraRange = val

    warn("Kill Aura Range: " .. val)

end})

killAuraSection:Slider({Name = "Target Health %", Default = targetHealthPercent, Minimum = 1, Maximum = 100, Decimals = 0, Suffix = "%", Callback = function(val) 

    targetHealthPercent = val

    warn("Target Health %: " .. val)

end})

killAuraSection:Toggle({Name = "Freeze Mobs", Default = freezeMobsEnabled, Callback = function(val) 

    freezeMobsEnabled = val

    warn("Freeze Mobs: " .. tostring(val))

end})

killAuraSection:Slider({Name = "Freeze Range", Default = freezeRange, Minimum = 1, Maximum = 50, Decimals = 1, Suffix = " studs", Callback = function(val) 

    freezeRange = val

    warn("Freeze Range: " .. val)

end})

killAuraSection:Toggle({Name = "Auto Farm", Default = autoFarmEnabled, Callback = function(val) 

    autoFarmEnabled = val

    warn("Auto Farm: " .. tostring(val))

end})

killAuraSection:Slider({Name = "Farm Distance", Default = farmDistance, Minimum = 1, Maximum = 20, Decimals = 1, Suffix = " studs", Callback = function(val) 

    farmDistance = val

    warn("Farm Distance: " .. val)

end})

killAuraSection:Label({Name = "Position Relative to NPC"})



local positionOptions = {"Above", "Under", "Orbit", "Behind", "Front"}

for _, option in pairs(positionOptions) do

    killAuraSection:Toggle({Name = option, Default = option == positionRelative, Callback = function(val) 

        if val then

            positionRelative = option



            warn("Position selected: " .. option)

        end

    end})

end

killAuraSection:Toggle({Name = "Auto Grip", Default = autoGripEnabled, Callback = function(val) 

    autoGripEnabled = val

    warn("Auto Grip: " .. tostring(val))

end})



local autoMissionEnabled = false

local selectedMission = nil

local tpToMissionEnabled = false

local autoLootEnabled = false

local autoHitEnabled = false



missionSection:Toggle({Name = "Auto Mission", Default = autoMissionEnabled, Callback = function(val) 

    autoMissionEnabled = val

    warn("Auto Mission: " .. tostring(val))

end})

missionSection:Label({Name = "Mission Selection"})



local missionOptions = {"Bandit Camp", "Pirate Raid", "Castle Defense", "Dungeon Run", "Boss Hunt"}

for _, mission in pairs(missionOptions) do

    missionSection:Button({Name = mission, Callback = function() 

        selectedMission = mission

        warn("Selected mission: " .. mission)



    end})

end



missionSection:Toggle({Name = "TP to Mission", Default = tpToMissionEnabled, Callback = function(val) 

    tpToMissionEnabled = val

    warn("TP to Mission: " .. tostring(val))

end})

missionSection:Toggle({Name = "Auto Loot", Default = autoLootEnabled, Callback = function(val) 

    autoLootEnabled = val

    warn("Auto Loot: " .. tostring(val))

end})

missionSection:Toggle({Name = "Auto Hit", Default = autoHitEnabled, Callback = function(val) 

    autoHitEnabled = val

    warn("Auto Hit: " .. tostring(val))

end})



local raidSection = raidsTab:Section({Name = "Raid Controls", size = 400})

local raidStatsSection = raidsTab:Section({Name = "Raid Statistics", size = 400, Side = "Right"})



local autoLaunchRaidEnabled = false

local selectedRaidBoss = nil

local autoRaidEnabled = false

local autoRetryEnabled = false

local raidStats = {

    completed = 0,

    failed = 0,

    successRate = "0%",

    averageTime = "0:00",

    bestTime = "0:00"

}



raidSection:Toggle({Name = "Auto Launch Raid", Default = autoLaunchRaidEnabled, Callback = function(val) 

    autoLaunchRaidEnabled = val

    warn("Auto Launch Raid: " .. tostring(val))

end})

raidSection:Label({Name = "Raid Boss Selection"})



local raidBosses = {"Dragon King", "Shadow Demon", "Ice Giant", "Elemental Lord", "Void Walker"}

for _, boss in pairs(raidBosses) do

    raidSection:Button({Name = boss, Callback = function() 

        selectedRaidBoss = boss

        warn("Selected raid boss: " .. boss)

    end})

end



raidSection:Toggle({Name = "Auto Raid", Default = autoRaidEnabled, Callback = function(val) 

    autoRaidEnabled = val

    warn("Auto Raid: " .. tostring(val))

end})

raidSection:Toggle({Name = "Auto Retry", Default = autoRetryEnabled, Callback = function(val) 

    autoRetryEnabled = val

    warn("Auto Retry: " .. tostring(val))

end})

raidSection:Button({Name = "Force Start Raid", Callback = function() 

    warn("Force starting raid")



end})



raidStatsSection:Label({Name = "Raid Statistics"})

local completedLabel = raidStatsSection:Label({Name = "Completed: " .. raidStats.completed})

local failedLabel = raidStatsSection:Label({Name = "Failed: " .. raidStats.failed})

local successRateLabel = raidStatsSection:Label({Name = "Success Rate: " .. raidStats.successRate})

local avgTimeLabel = raidStatsSection:Label({Name = "Average Time: " .. raidStats.averageTime})

local bestTimeLabel = raidStatsSection:Label({Name = "Best Time: " .. raidStats.bestTime})



raidStatsSection:Button({Name = "Reset Statistics", Callback = function() 

    raidStats = {

        completed = 0,

        failed = 0,

        successRate = "0%",

        averageTime = "0:00",

        bestTime = "0:00"

    }



    completedLabel:Set("Completed: " .. raidStats.completed)

    failedLabel:Set("Failed: " .. raidStats.failed)

    successRateLabel:Set("Success Rate: " .. raidStats.successRate)

    avgTimeLabel:Set("Average Time: " .. raidStats.averageTime)

    bestTimeLabel:Set("Best Time: " .. raidStats.bestTime)



    warn("Reset raid statistics")

end})



local function getInstancePosition(instance)

    if not instance then return nil end



    if instance:IsA("BasePart") then

        return instance.Position

    elseif instance:IsA("Model") then

        return instance:GetPivot().Position

    else

        local primaryPart = instance.PrimaryPart

        local rootPart = instance:FindFirstChild("HumanoidRootPart")

        local reference = primaryPart or rootPart or instance:FindFirstChildWhichIsA("BasePart")



        if reference then

            return reference.Position

        end

    end

    return nil

end



local function getDistance(pos1, pos2)

    return (pos1 - pos2).Magnitude

end



local function getPlayerDistance(instance)

    local character = LocalPlayer.Character

    local rootPart = character and character:FindFirstChild("HumanoidRootPart")



    if not rootPart then return 0 end



    local targetPosition = getInstancePosition(instance)

    if not targetPosition then return 0 end



    return getDistance(rootPart.Position, targetPosition)

end



local function getDrawing(id, type, properties)

    if not cache.drawings[id] then

        cache.drawings[id] = Drawing.new(type)



        for prop, value in pairs(properties) do

            cache.drawings[id][prop] = value

        end

    end



    return cache.drawings[id]

end



local function identifyEntityType(entity)

    if not entity then return "unknown" end



    if entity.Name:match("^Humanoid_[%w%-]+$") or entity.Name:match("^%(.-%)Humanoid_[%w%-]+$") then 

        return "npc" 

    end



    if entity:IsA("Player") or Players:FindFirstChild(entity.Name) then

        return "player"

    end



    if entity.Name == "giftbox_blend" and entity:FindFirstChild("Giftbox01") then

        return "lootbox"

    end



    if entity.Name == "Lootbag" then

        return "lootbag"

    end



    return "unknown"

end



local function extractNPCName(name)

    local tag = "NPC"

    return tag or "NPC"

end



local function updateESP()

    if not ESP.Enabled then



        for id, drawing in pairs(cache.drawings) do

            drawing.Visible = false

        end

        return

    end



    local playerCharacter = LocalPlayer.Character

    local playerRoot = playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart")

    if not playerRoot then return end



    local playerPosition = playerRoot.Position



    for id, data in pairs(cache.espData) do

        local entity = data.entity

        local entityType = data.type



        if not entity or not entity.Parent then



            if cache.drawings[id .. "_text"] then

                cache.drawings[id .. "_text"].Visible = false

            end

            cache.espData[id] = nil

            continue

        end



        local position

        local humanoid



        if entityType == "player" then

            local character = entity.Character

            if not character then continue end



            local rootPart = character:FindFirstChild("HumanoidRootPart")

            if not rootPart then continue end



            position = rootPart.Position

            humanoid = character:FindFirstChild("Humanoid")

        elseif entityType == "npc" then

            local rootPart = entity:FindFirstChild("HumanoidRootPart")

            if not rootPart then continue end



            position = rootPart.Position

            humanoid = entity:FindFirstChild("Humanoid")

        else

            position = getInstancePosition(entity)

            if not position then continue end

        end



        local distance = getDistance(playerPosition, position)

        local config = ESP[entityType == "player" and "Players" or

                         entityType == "npc" and "NPCs" or

                         entityType == "lootbox" and "LootBoxes" or

                         entityType == "lootbag" and "LootBags"]



        if not config or not config.Enabled or distance > config.MaxDistance then



            if cache.drawings[id .. "_text"] then

                cache.drawings[id .. "_text"].Visible = false

            end

            continue

        end



        local screenPos, onScreen = camera:WorldToViewportPoint(position)

        if not onScreen then

            if cache.drawings[id .. "_text"] then

                cache.drawings[id .. "_text"].Visible = false

            end

            continue

        end



        local basePosition = Vector2.new(screenPos.X, screenPos.Y)

        local scaleFactor = 1 / (screenPos.Z * 0.75)

        local textOffset = Vector2.new(0, -45 * scaleFactor)



        local displayText = ""



        if entityType == "player" then

            displayText = entity.Name



            if config.ShowHealth and humanoid then

                displayText = string.format("%s [%d/%d]", displayText, 

                    math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))

            end

        elseif entityType == "npc" then

            displayText = extractNPCName(entity.Name)



            if config.ShowHealth and humanoid then

                displayText = string.format("%s [%d/%d]", displayText, 

                    math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))

            end

        elseif entityType == "lootbox" then

            displayText = "Loot Box"

        elseif entityType == "lootbag" then

            displayText = "Loot Bag"

        end



        if config.ShowDistance then

            displayText = string.format("%s [%d]", displayText, math.floor(distance))

        end



        local textDrawing = getDrawing(id .. "_text", "Text", {

            Text = displayText,

            Size = config.TextSize,

            Center = true,

            Outline = true,

            OutlineColor = config.OutlineColor,

            Color = config.TextColor,

            Font = 2,

            Visible = true

        })



        textDrawing.Text = displayText

        textDrawing.Position = basePosition + textOffset

        textDrawing.Visible = true

    end

end



local function monitorPlayers()

    local function trackPlayer(player)

        if player == LocalPlayer then return end



        local id = "player_" .. player.UserId



        cache.espData[id] = {

            entity = player,

            type = "player"

        }

    end



    for _, player in pairs(Players:GetPlayers()) do

        trackPlayer(player)

    end



    Players.PlayerAdded:Connect(trackPlayer)



    Players.PlayerRemoving:Connect(function(player)

        local id = "player_" .. player.UserId

        cache.espData[id] = nil



        if cache.drawings[id .. "_text"] then

            cache.drawings[id .. "_text"].Visible = false

        end

    end)

end



local function monitorNPCs()



    local function scanForNPCs()



        local entities = workspace:FindFirstChild("Entities")



        if entities then

            for _, entity in pairs(entities:GetChildren()) do

                if identifyEntityType(entity) == "npc" then

                    local id = "npc_" .. entity.Name



                    if not cache.espData[id] then

                        cache.espData[id] = {

                            entity = entity,

                            type = "npc"

                        }

                    end

                end

            end

        end



        for _, entity in pairs(workspace:GetChildren()) do

            if identifyEntityType(entity) == "npc" then

                local id = "npc_" .. entity.Name



                if not cache.espData[id] then

                    cache.espData[id] = {

                        entity = entity,

                        type = "npc"

                    }

                end

            end

        end

    end



    scanForNPCs()



    spawn(function()

        while wait(0.1) do 

            scanForNPCs()

        end

    end)



    workspace.DescendantAdded:Connect(function(descendant)

        if identifyEntityType(descendant) == "npc" then

            local id = "npc_" .. descendant.Name



            if not cache.espData[id] then

                cache.espData[id] = {

                    entity = descendant,

                    type = "npc"

                }

            end

        end

    end)

end



local function monitorLootBoxes()

    local function scanForLootBoxes()

        for _, model in pairs(workspace:GetDescendants()) do

            if model.Name == "giftbox_blend" and model:FindFirstChild("Giftbox01") then

                local id = "lootbox_" .. model:GetFullName()



                if not cache.espData[id] then

                    cache.espData[id] = {

                        entity = model,

                        type = "lootbox"

                    }

                end

            end

        end

    end



    scanForLootBoxes()



    spawn(function()

        while wait(0.1) do 

            scanForLootBoxes()

        end

    end)



    workspace.DescendantAdded:Connect(function(descendant)

        if descendant.Name == "Giftbox01" and descendant.Parent and descendant.Parent.Name == "giftbox_blend" then

            local id = "lootbox_" .. descendant.Parent:GetFullName()



            if not cache.espData[id] then

                cache.espData[id] = {

                    entity = descendant.Parent,

                    type = "lootbox"

                }

            end

        end

    end)

end



local function monitorLootBags()

    local function scanForLootBags()

        local lootBagsFolder = workspace:FindFirstChild("Lootbags")

        if not lootBagsFolder then return end



        for _, lootBag in pairs(lootBagsFolder:GetChildren()) do

            if lootBag.Name == "Lootbag" then

                local id = "lootbag_" .. lootBag:GetFullName()



                if not cache.espData[id] then

                    cache.espData[id] = {

                        entity = lootBag,

                        type = "lootbag"

                    }

                end

            end

        end

    end



    scanForLootBags()



    spawn(function()

        while wait(0.1) do 

            scanForLootBags()

        end

    end)



    local lootBagsFolder = workspace:FindFirstChild("Lootbags")

    if lootBagsFolder then

        lootBagsFolder.ChildAdded:Connect(function(child)

            if child.Name == "Lootbag" then

                local id = "lootbag_" .. child:GetFullName()



                if not cache.espData[id] then

                    cache.espData[id] = {

                        entity = child,

                        type = "lootbag"

                    }

                end

            end

        end)



        lootBagsFolder.ChildRemoved:Connect(function(child)

            local id = "lootbag_" .. child:GetFullName()

            cache.espData[id] = nil

        end)

    end



    workspace.ChildAdded:Connect(function(child)

        if child.Name == "Lootbags" then

            child.ChildAdded:Connect(function(lootBag)

                if lootBag.Name == "Lootbag" then

                    local id = "lootbag_" .. lootBag:GetFullName()



                    if not cache.espData[id] then

                        cache.espData[id] = {

                            entity = lootBag,

                            type = "lootbag"

                        }

                    end

                end

            end)



            child.ChildRemoved:Connect(function(lootBag)

                local id = "lootbag_" .. lootBag:GetFullName()

                cache.espData[id] = nil

            end)



            for _, lootBag in pairs(child:GetChildren()) do

                if lootBag.Name == "Lootbag" then

                    local id = "lootbag_" .. lootBag:GetFullName()



                    if not cache.espData[id] then

                        cache.espData[id] = {

                            entity = lootBag,

                            type = "lootbag"

                        }

                    end

                end

            end

        end

    end)

end



local function init()

    monitorPlayers()

    monitorNPCs()

    monitorLootBoxes()

    monitorLootBags()



    RunService.RenderStepped:Connect(updateESP)



end



init()



combatTab:Turn(true)



return library, utility, obelus
