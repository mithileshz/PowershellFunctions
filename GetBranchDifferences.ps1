## This function will return the differences of a branch on remote compared to the upstream origin/master.
## It will create a temporary branch with the name on line 13.

function GetBranchDifferences
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$branch
    )
     
    $localTemporaryBranchName = 'TEMPORARY.BRANCH.NAME'; # Replace this
    
    $branchWithRefsHead = -join("refs/heads/", $branch);
    
    $existingTemporaryBranch = git for-each-ref --format='%(refname:short)' $branchWithRefsHead;
     
    if ($existingTemporaryBranch -eq $localTemporaryBranchName) {
        git branch -D $localTemporaryBranchName # Force delete the branch as the HEAD of this branch may be out of sync with master
    }
     
    git fetch origin;
    git checkout -b $localTemporaryBranchName origin/master; # Create new branch based on the remote master
    $branchNameForMerge = -join("origin/", $branch);
    git merge $branchNameForMerge --no-commit --no-ff;
     
    Write-Host "Success!" -ForegroundColor Green;
}
