# Ne pas oublier de permettre à la nouvelle vm de récupérer le mot de passe du gMSA
# Set-ADServiceAccount -Identity srvsql-server -PrincipalsAllowedToRetrieveManagedPassword server$, server$

#Paramètres
$gmsa = "srvsql-server$"

$paths = @("S:\Backup", "S:\Data", "D:\TempDB", "L:\Logs", "L:\Temp")


foreach($path in $paths){
    New-Item -Path $path -ItemType Directory

    $acl = Get-Acl $path

    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        $gmsa, 
        "FullControl", 
        "ContainerInherit,ObjectInherit", 
        "None", 
        "Allow"
    )

    $acl.AddAccessRule($rule)
    Set-Acl -Path $path -AclObject $acl

    Get-Acl $path | Format-List
}

New-Item -Path "L:\Temp\FullQryAudit"  -ItemType Directory

Set-NetFirewallProfile -Enabled False
