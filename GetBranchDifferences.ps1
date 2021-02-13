function GetBranchDifferences
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$branch
    )
     
    $localTemporaryBranchName = 'user/FIRSTNAME.LASTNAME/TEMPORARY.BRANCH.NAME'; # Replace this
     
    $existingTemporaryBranch = git branch --list $localTemporaryBranchName;
     
    if ($existingTemporaryBranch -like "*$localTemporaryBranchName") {
        git branch -D $localTemporaryBranchName # Force delete the branch as the HEAD of this branch may be out of sync with master
    }
     
    git fetch origin;
    git checkout -b $localTemporaryBranchName origin/master; # Create new branch based on the remote master
    $branchNameForMerge = -join("origin/", $branch);
    git merge $branchNameForMerge --no-commit --no-ff;
     
    Write-Host "Success!" -ForegroundColor Green;
}
