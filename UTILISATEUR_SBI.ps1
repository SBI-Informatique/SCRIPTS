New-LocalUser -Name $param1 -Description "Son of Goku" -Password $param2

net user %1 %2 /add
net user %1 /active:yes
net localgroup administrateurs %1 /add
