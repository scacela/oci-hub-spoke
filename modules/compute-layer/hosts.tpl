%{ for i, j in hub_displaynames_and_privateips ~}
${i} ${j}
%{ endfor ~}
%{ for i, j in spoke_displaynames_and_privateips ~}
${i} ${j}
%{ endfor ~}