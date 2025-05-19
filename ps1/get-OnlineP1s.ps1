get-content "\\some\path\here" | 

foreach-object {

if (Test-Connection $_ -count 1 -Quiet ) {

# write-output "$_ online"

Write-Host -f green "$_ online"

}

else {

#write-output "$_ Failed to connect" (get-date) | 

write-output "$_" |

out-file "\\some\path\here" -append

}

} 

# |

#out-file "\\some\path\here" -append
