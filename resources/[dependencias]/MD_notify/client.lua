RegisterNetEvent('MD_ShowTopNotification')
AddEventHandler('MD_ShowTopNotification', function(title, subtext, duration)
    exports.MD_notify.ShowTopNotification(0, tostring(title), tostring(subtext), tonumber(duration))
end)



RegisterNetEvent("MD_notify:Toast")
AddEventHandler("MD_notify:Toast",function(icon,title,mensagem, time)
	if icon == "alert" then
		exports['MD_notify']:DisplayLeftNotification(title,mensagem,'HUD_TOASTS','toast_mp_status_change',time)	
	end

	if icon == "verify" then
		exports['MD_notify']:DisplayLeftNotification(title,mensagem,'generic_textures','tick',time)	
	end

	if icon == "falha" then
		exports['MD_notify']:DisplayLeftNotification(title,mensagem,'menu_textures','cross',time)	
	end

	if icon == "star" then
		exports['MD_notify']:DisplayLeftNotification(title,mensagem,'generic_textures','star',time)	
	end	
	
	if icon == "horse" then
		exports['MD_notify']:DisplayLeftNotification(title,mensagem,'HUD_TOASTS','toast_horse_bond',time)	
	end

	if icon == "comida" then
		exports['MD_notify']:DisplayLeftNotification(title,mensagem,'pm_awards_mp','awards_set_d_004',time)	
	end

	if icon == "transform" then
		exports['MD_notify']:DisplayLeftNotification(title,mensagem,'pm_awards_mp','awards_set_s_003',time)	
	end

	if icon == "roubo" then
		exports['MD_notify']:DisplayLeftNotification(title,mensagem,'pm_awards_mp','awards_set_h_006',time)	
	end

end)

RegisterNetEvent("MD_notify:Simple")
AddEventHandler("MD_notify:Simple",function(mensagem, time)
	SendNUIMessage({ css = 'sucesso', mensagem = mensagem, time =  time })
end)