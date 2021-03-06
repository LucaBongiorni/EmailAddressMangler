﻿function Invoke-EmailAddressMangler{
    <#
    .SYNOPSIS
    This module mangles two lists of names together to generate a list of potential email addresses or usernames. It can also be used to simply combine a list of full names in the format (firstname lastname) into either email addresses or usernames.

    Invoke-EmailAddressMangler
    Author: Beau Bullock (@dafthack)
    License: BSD 3-Clause
    Required Dependencies: None
    Optional Dependencies: None

    .DESCRIPTION

    This module mangles two lists of names together to generate a list of potential email addresses or usernames. It can also be used to simply combine a list of full names in the format (firstname lastname) into either email addresses or usernames.

    .PARAMETER FirstNamesList
    
    A list of first names one per line.

    .PARAMETER LastNamesList

    A list of last names one per line.

    .PARAMETER SimpleMergeList

    A list of full names one per line in the format 'firstname lastname'. If this option is specified the tool will simple merge the names together as opposed to mangling all possible combinations.

    .PARAMETER Domain

    The domain to append to each email address. If the -Domain option is not specified a username list will be generated.

    .PARAMETER AddressConvention

    The email address or username naming convention. fn=firstname, ln=lastname, fi=fistinitial, li=lastinitial The following are acceptable formats: fnln, fn-ln, fn.ln, filn, fi-ln, fi.ln, fnli, fn-li, fn.li, lnfn, ln-fn, ln.fn, lifn, li-fn, li.fn, lnfi, ln-fi, ln.fi fn, ln.

    .EXAMPLE 

    C:\PS> Invoke-EmailAddressMangler -FirstNamesList .\namelists\top_100_male_female_first_names.txt -LastNamesList .\namelists\top_100_last_names.txt -AddressConvention fnli -Domain testing.com | Out-File -Encoding ascii emailaddresses.txt

    Description
    -----------
    This command will merge the top 100 male/female first names with the top 100 last names into a list of email addresses of format firstnamelastinitial@testing.com (ex. johns@testing.com) and write it to a file called emailaddresses.txt.

    .EXAMPLE 

    C:\PS> Invoke-EmailAddressMangler -SimpleMergeList .\listofnamestomerge.txt -AddressConvention ln.fi | Out-File -Encoding ascii usernames.txt

    Description
    -----------
    This command will perform a simple merge of a list of full names (john smith) one per line into a list of usernames in the format lastname.firstinitial (ex. smith.j) and write it to a file called usernames.txt.
    #>
    Param(

     [Parameter(Position = 0, Mandatory = $false)]
     [string]
     $FirstNamesList = "",

     [Parameter(Position = 1, Mandatory = $false)]
     [string]
     $LastNamesList = "",

     [Parameter(Position = 2, Mandatory = $false)]
     [string]
     $SimpleMergeList = "",

     [Parameter(Position = 3, Mandatory = $false)]
     [string]
     $Domain = "",

     [Parameter(Position = 4, Mandatory = $false)]
     [string]
     $AddressConvention = ""

    )

    $ErrorActionPreference = "SilentlyContinue"
    $FNameArray = @()
    $LNameArray = @()
    $FullUserList = @()
    

    #Simple merged list basically just takes a list of full names (first last) one per line and merges them together in the specified format.
    if ($SimpleMergeList -ne "")
    {
        if ($Domain -ne "")
        {
            Write-Host -foregroundcolor "yellow" "[*] Now generating the mangled email address list. Please wait..."
        }
        else 
        {
            Write-Host -foregroundcolor "yellow" "[*] Now generating the mangled username list. Please wait..."
        }
        if ($Domain -ne "")
        {
            #Read in the raw list
            $RawMergeList = Get-Content $SimpleMergeList
            foreach($fullname in $RawMergeList)
            {
                try
                {
                    $fname,$lname = $fullname.split(' ',2)
                }
                catch
                {
                    $fname = $fullname
                    $lname = $fullname
                } 
                if($AddressConvention -eq "fnln")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $FullUserList += "$fname$lname@$Domain"
                }
                elseif($AddressConvention -eq "fn.ln")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $FullUserList += "$fname.$lname@$Domain"
                }
                elseif($AddressConvention -eq "fn-ln")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $FullUserList += "$fname-$lname@$Domain"
                }
                elseif($AddressConvention -eq "filn")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $finit = $fname.Substring(0,1)
                    $FullUserList += "$finit$lname@$Domain"
                }
                elseif($AddressConvention -eq "fi-ln")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $finit = $fname.Substring(0,1)
                    $FullUserList += "$finit-$lname@$Domain"
                }
                elseif($AddressConvention -eq "fi.ln")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $finit = $fname.Substring(0,1)
                    $FullUserList += "$finit.$lname@$Domain"
                }
                elseif($AddressConvention -eq "fnli")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $linit = $lname.Substring(0,1)
                    $FullUserList += "$fname$linit@$Domain"
                }
                elseif($AddressConvention -eq "fn-li")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $linit = $lname.Substring(0,1)
                    $FullUserList += "$fname-$linit@$Domain"
                }
                elseif($AddressConvention -eq "fn.li")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $linit = $lname.Substring(0,1)
                    $FullUserList += "$fname.$linit@$Domain"
                }
                elseif($AddressConvention -eq "fn")
                {
                    $fname = $fname.ToLower()
                    $FullUserList += "$fname@$Domain"
                }
                elseif($AddressConvention -eq "ln")
                {
                    $lname = $lname.ToLower()
                    $FullUserList += "$lname@$Domain"
                }
                elseif($AddressConvention -eq "lnfn")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $FullUserList += "$lname$fname@$Domain"
                }
                elseif($AddressConvention -eq "ln.fn")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $FullUserList += "$lname.$fname@$Domain"
                }
                elseif($AddressConvention -eq "ln-fn")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $FullUserList += "$lname-$fname@$Domain"
                }
                elseif($AddressConvention -eq "lifn")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $finit = $fname.Substring(0,1)
                    $FullUserList += "$linit$fname@$Domain"
                }
                elseif($AddressConvention -eq "li-fn")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $linit = $lname.Substring(0,1)
                    $FullUserList += "$linit-$fname@$Domain"
                }
                elseif($AddressConvention -eq "li.fn")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $linit = $lname.Substring(0,1)
                    $FullUserList += "$linit.$fname@$Domain"
                }
                elseif($AddressConvention -eq "lnfi")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $finit = $fname.Substring(0,1)
                    $FullUserList += "$lname$finit@$Domain"
                }
                elseif($AddressConvention -eq "ln-fi")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $finit = $fname.Substring(0,1)
                    $FullUserList += "$lname-$finit@$Domain"
                }
                elseif($AddressConvention -eq "ln.fi")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $finit = $fname.Substring(0,1)
                    $FullUserList += "$lname.$finit@$Domain"
                }
                else
                {
                Write-Host -ForegroundColor "red" "[*] Please enter an email address naming convention with the -AddressConvention flag."
                Write-Host -ForegroundColor "red" "[*] Accepted formats include fnln, filn, fn.ln, fn etc. where fn = first name, ln = last name, fi = first initial, and li = last initial."
                return
                }
            }
        }
        else
        {
            #if no domain was entered just make a username list
            $RawMergeList = Get-Content $SimpleMergeList
            foreach($fullname in $RawMergeList)
            {
                try
                {
                    $fname,$lname = $fullname.split(' ',2)
                }
                catch
                {
                    $fname = $fullname
                    $lname = $fullname
                } 
                if($AddressConvention -eq "fnln")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $FullUserList += "$fname$lname"
                }
                elseif($AddressConvention -eq "fn.ln")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $FullUserList += "$fname.$lname"
                }
                elseif($AddressConvention -eq "fn-ln")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $FullUserList += "$fname-$lname"
                }
                elseif($AddressConvention -eq "filn")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $finit = $fname.Substring(0,1)
                    $FullUserList += "$finit$lname"
                }
                elseif($AddressConvention -eq "fi-ln")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $finit = $fname.Substring(0,1)
                    $FullUserList += "$finit-$lname"
                }
                elseif($AddressConvention -eq "fi.ln")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $finit = $fname.Substring(0,1)
                    $FullUserList += "$finit.$lname"
                }
                elseif($AddressConvention -eq "fnli")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $linit = $lname.Substring(0,1)
                    $FullUserList += "$fname$linit"
                }
                elseif($AddressConvention -eq "fn-li")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $linit = $lname.Substring(0,1)
                    $FullUserList += "$fname-$linit"
                }
                elseif($AddressConvention -eq "fn.li")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $linit = $lname.Substring(0,1)
                    $FullUserList += "$fname.$linit"
                }
                elseif($AddressConvention -eq "fn")
                {
                    $fname = $fname.ToLower()
                    $FullUserList += "$fname"
                }
                elseif($AddressConvention -eq "ln")
                {
                    $lname = $lname.ToLower()
                    $FullUserList += "$lname"
                }
                elseif($AddressConvention -eq "lnfn")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $FullUserList += "$lname$fname"
                }
                elseif($AddressConvention -eq "ln.fn")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $FullUserList += "$lname.$fname"
                }
                elseif($AddressConvention -eq "ln-fn")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $FullUserList += "$lname-$fname"
                }
                elseif($AddressConvention -eq "lifn")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $finit = $fname.Substring(0,1)
                    $FullUserList += "$linit$fname"
                }
                elseif($AddressConvention -eq "li-fn")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $linit = $lname.Substring(0,1)
                    $FullUserList += "$linit-$fname"
                }
                elseif($AddressConvention -eq "li.fn")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $linit = $lname.Substring(0,1)
                    $FullUserList += "$linit.$fname"
                }
                elseif($AddressConvention -eq "lnfi")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $finit = $fname.Substring(0,1)
                    $FullUserList += "$lname$finit"
                }
                elseif($AddressConvention -eq "ln-fi")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $finit = $fname.Substring(0,1)
                    $FullUserList += "$lname-$finit"
                }
                elseif($AddressConvention -eq "ln.fi")
                {
                    $fname = $fname.ToLower()
                    $lname = $lname.ToLower()
                    $finit = $fname.Substring(0,1)
                    $FullUserList += "$lname.$finit"
                }
                else
                {
                Write-Host -ForegroundColor "red" "[*] Please enter an email address naming convention with the -AddressConvention flag."
                Write-Host -ForegroundColor "red" "[*] Accepted formats include fnln, filn, fn.ln, fn etc. where fn = first name, ln = last name, fi = first initial, and li = last initial."
                return
                }
            }  
        }
    }
    else
    {
        #if simpe merge list is not selected mangle the first and last name lists together to generate a list of all possible combos.
        $FNameArray = Get-Content $FirstNamesList
        $LNameArray = Get-Content $LastNamesList
    
        if ($Domain -ne "")
        {
            Write-Host -foregroundcolor "yellow" "[*] Now generating the mangled email address list. Please wait..."
        }
        else 
        {
            Write-Host -foregroundcolor "yellow" "[*] Now generating the mangled username list. Please wait..."
        }
        foreach($fname in $FNameArray)
        {
            if ($Domain -ne "")
            {
            
                foreach($lname in $LNameArray)
                {
                    if($AddressConvention -eq "fnln")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $FullUserList += "$fname$lname@$Domain"
                    }
                    elseif($AddressConvention -eq "fn.ln")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $FullUserList += "$fname.$lname@$Domain"
                    }
                    elseif($AddressConvention -eq "fn-ln")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $FullUserList += "$fname-$lname@$Domain"
                    }
                    elseif($AddressConvention -eq "filn")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $finit = $fname.Substring(0,1)
                        $FullUserList += "$finit$lname@$Domain"
                    }
                    elseif($AddressConvention -eq "fi-ln")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $finit = $fname.Substring(0,1)
                        $FullUserList += "$finit-$lname@$Domain"
                    }
                    elseif($AddressConvention -eq "fi.ln")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $finit = $fname.Substring(0,1)
                        $FullUserList += "$finit.$lname@$Domain"
                    }
                    elseif($AddressConvention -eq "fnli")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $linit = $lname.Substring(0,1)
                        $FullUserList += "$fname$linit@$Domain"
                    }
                    elseif($AddressConvention -eq "fn-li")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $linit = $lname.Substring(0,1)
                        $FullUserList += "$fname-$linit@$Domain"
                    }
                    elseif($AddressConvention -eq "fn.li")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $linit = $lname.Substring(0,1)
                        $FullUserList += "$fname.$linit@$Domain"
                    }
                    elseif($AddressConvention -eq "fn")
                    {
                        $fname = $fname.ToLower()
                        $FullUserList += "$fname@$Domain"
                    }
                    elseif($AddressConvention -eq "ln")
                    {
                        $lname = $lname.ToLower()
                        $FullUserList += "$lname@$Domain"
                    }
                    elseif($AddressConvention -eq "lnfn")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $FullUserList += "$lname$fname@$Domain"
                    }
                    elseif($AddressConvention -eq "ln.fn")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $FullUserList += "$lname.$fname@$Domain"
                    }
                    elseif($AddressConvention -eq "ln-fn")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $FullUserList += "$lname-$fname@$Domain"
                    }
                    elseif($AddressConvention -eq "lifn")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $finit = $fname.Substring(0,1)
                        $FullUserList += "$linit$fname@$Domain"
                    }
                    elseif($AddressConvention -eq "li-fn")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $linit = $lname.Substring(0,1)
                        $FullUserList += "$linit-$fname@$Domain"
                    }
                    elseif($AddressConvention -eq "li.fn")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $linit = $lname.Substring(0,1)
                        $FullUserList += "$linit.$fname@$Domain"
                    }
                    elseif($AddressConvention -eq "lnfi")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $finit = $fname.Substring(0,1)
                        $FullUserList += "$lname$finit@$Domain"
                    }
                    elseif($AddressConvention -eq "ln-fi")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $finit = $fname.Substring(0,1)
                        $FullUserList += "$lname-$finit@$Domain"
                    }
                    elseif($AddressConvention -eq "ln.fi")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $finit = $fname.Substring(0,1)
                        $FullUserList += "$lname.$finit@$Domain"
                    }
                    else
                    {
                    Write-Host -ForegroundColor "red" "[*] Please enter an email address naming convention with the -AddressConvention flag."
                    Write-Host -ForegroundColor "red" "[*] Accepted formats include fnln, filn, fn.ln, fn etc. where fn = first name, ln = last name, fi = first initial, and li = last initial."
                    return
                    }
                }
            }
            else
            {
                #If no domain is selected it just creates a username list
                foreach($lname in $LNameArray)
                {
                    if($AddressConvention -eq "fnln")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $FullUserList += "$fname$lname"
                    }
                    elseif($AddressConvention -eq "fn.ln")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $FullUserList += "$fname.$lname"
                    }
                    elseif($AddressConvention -eq "fn-ln")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $FullUserList += "$fname-$lname"
                    }
                    elseif($AddressConvention -eq "filn")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $finit = $fname.Substring(0,1)
                        $FullUserList += "$finit$lname"
                    }
                    elseif($AddressConvention -eq "fi-ln")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $finit = $fname.Substring(0,1)
                        $FullUserList += "$finit-$lname"
                    }
                    elseif($AddressConvention -eq "fi.ln")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $finit = $fname.Substring(0,1)
                        $FullUserList += "$finit.$lname"
                    }
                    elseif($AddressConvention -eq "fnli")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $linit = $lname.Substring(0,1)
                        $FullUserList += "$fname$linit"
                    }
                    elseif($AddressConvention -eq "fn-li")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $linit = $lname.Substring(0,1)
                        $FullUserList += "$fname-$linit"
                    }
                    elseif($AddressConvention -eq "fn.li")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $linit = $lname.Substring(0,1)
                        $FullUserList += "$fname.$linit"
                    }
                    elseif($AddressConvention -eq "fn")
                    {
                        $fname = $fname.ToLower()
                        $FullUserList += "$fname"
                    }
                    elseif($AddressConvention -eq "ln")
                    {
                        $lname = $lname.ToLower()
                        $FullUserList += "$lname"
                    }
                    elseif($AddressConvention -eq "lnfn")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $FullUserList += "$lname$fname"
                    }
                    elseif($AddressConvention -eq "ln.fn")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $FullUserList += "$lname.$fname"
                    }
                    elseif($AddressConvention -eq "ln-fn")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $FullUserList += "$lname-$fname"
                    }
                    elseif($AddressConvention -eq "lifn")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $finit = $fname.Substring(0,1)
                        $FullUserList += "$linit$fname"
                    }
                    elseif($AddressConvention -eq "li-fn")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $linit = $lname.Substring(0,1)
                        $FullUserList += "$linit-$fname"
                    }
                    elseif($AddressConvention -eq "li.fn")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $linit = $lname.Substring(0,1)
                        $FullUserList += "$linit.$fname"
                    }
                    elseif($AddressConvention -eq "lnfi")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $finit = $fname.Substring(0,1)
                        $FullUserList += "$lname$finit"
                    }
                    elseif($AddressConvention -eq "ln-fi")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $finit = $fname.Substring(0,1)
                        $FullUserList += "$lname-$finit"
                    }
                    elseif($AddressConvention -eq "ln.fi")
                    {
                        $fname = $fname.ToLower()
                        $lname = $lname.ToLower()
                        $finit = $fname.Substring(0,1)
                        $FullUserList += "$lname.$finit"
                    }
                    else
                    {
                    Write-Host -ForegroundColor "red" "[*] Please enter an email address naming convention with the -AddressConvention flag."
                    Write-Host -ForegroundColor "red" "[*] Accepted formats include fnln, filn, fn.ln, fn etc. where fn = first name, ln = last name, fi = first initial, and li = last initial."
                    return
                    }
                }
            }
        }
    }
    $FullUserList = $FullUserList | sort | Get-Unique
    Write-Output $FullUserList
}