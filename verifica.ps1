# Check-SystemMailboxGuids.ps1
# 
# This script checks for SystemMailbox objects that have GUIDs
# which correspond to nonexistent databases.

#####
#
# Change this to the MESO container you want to check
# 

$mesoDN = "CN=Microsoft Exchange System Objects,DC=gruposaolucas,DC=com,DC=br"

#
#####

$mesoContainer = [ADSI]("LDAP://" + $mesoDN)
$sysMbxFinder = new-object System.DirectoryServices.DirectorySearcher
$sysMbxFinder.SearchRoot = $mesoContainer
$sysMbxFinder.PageSize = 1000
$sysMbxFinder.Filter = "(cn=SystemMailbox*)"
$sysMbxFinder.SearchScope = "OneLevel"

$sysMbxResults = $sysMbxFinder.FindAll()
"Found " + $sysMbxResults.Count + " System Mailboxes. Checking GUIDs..."

foreach ($result in $sysMbxResults)
{
	$cn = $result.Properties.cn[0]
	$guidStartIndex = $cn.IndexOf("{")
	$guidString = $cn.Substring($guidStartIndex + 1).TrimEnd("}")
	$guidEntry = [ADSI]("LDAP://<GUID=" + $guidString + ">")
##	if ($guidEntry.distinguishedName -eq $null)
##	{
		"Guid does not resolve: " + $cn
##	}
}

"Done!"
