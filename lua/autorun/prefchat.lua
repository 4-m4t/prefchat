if SERVER then

	util.AddNetworkString("prefchat-server")
	util.AddNetworkString("prefchat-client")

	local groups = {"superadmin", "admin"} -- player groups that can see prefchat
	local customPrefix = "." -- this is the trigger char for messaging with custom chat in chatbox.

	hook.Add( "PlayerSay", "prefchat-hook", function( ply, text )

		if ( string.StartWith( string.lower( text ), customPrefix ) ) then

			if !table.HasValue(groups, ply:GetUserGroup()) then return end -- checking if groups table has a player's group.

			for k, player in pairs(player.GetAll()) do

				if (table.HasValue(groups, player:GetUserGroup())) then -- checking which players can see custom chat message 

					net.Start("prefchat-client")
						net.WriteString(string.sub( text, 2 ))
						net.WriteString(ply:Name())
					net.Send(player)

				end
			end

			return false -- returning false because we don't want to see written command in chatbox
		end
	end )

else
	
	net.Receive("prefchat-client", function (len, ply)

		local text = net.ReadString()
		local name = net.ReadString()

		chat.AddText( Color( 64, 222, 250), '[prefchat]', Color( 64, 222, 250), name .. ': ' , Color( 46, 255, 80), text ) -- adding received message to selected players' chat
	end)

end
