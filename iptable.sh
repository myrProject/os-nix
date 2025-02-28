# Effacer les règles existantes
/run/current-system/sw/bin/iptables -F

# Bloquer tout le trafic par défaut
/run/current-system/sw/bin/iptables -P INPUT DROP
/run/current-system/sw/bin/iptables -P FORWARD DROP
/run/current-system/sw/bin/iptables -P OUTPUT DROP

# Autoriser HTTP et HTTPS
/run/current-system/sw/bin/iptables -A INPUT -p tcp --dport 80 -j ACCEPT
/run/current-system/sw/bin/iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Autoriser DNS
/run/current-system/sw/bin/iptables -A INPUT -p udp --dport 53 -j ACCEPT

# Autoriser le trafic sortant
/run/current-system/sw/bin/iptables -A OUTPUT -j ACCEPT

echo "Script de configuration de iptables terminé"
