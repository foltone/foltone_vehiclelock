Config = {
	Locale = "fr",

	CallESX = function (method, args, cb)
		ESX = exports["es_extended"]:getSharedObject()
	end,

	price = 500,

	key = "U",

	listKeyShop = {
		{ position = vector4(-27.00, -1089.86, 25.42, 102.33), pedModel = "s_m_m_ammucountry", pedScenario = "WORLD_HUMAN_CLIPBOARD" },
	},

	blip = {
		sprite = 811,
		color = 29,
		scale = 0.8,
		label = "Key Shop"
	},
	
	Notification = function (text)
		SetNotificationTextEntry("STRING")
		AddTextComponentString(text)
		DrawNotification(false, false)
	end,
	AddvancedNotification = function (title, subject, msg, icon, iconType)
		SetNotificationTextEntry("STRING")
		AddTextComponentString(msg)
		SetNotificationMessage(icon, icon, true, iconType, title, subject)
		DrawNotification(false, true)
	end,
	DisplayHelpText = function (text)
		SetTextComponentFormat("STRING")
		AddTextComponentString(text)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
	end,
}
