function GetBranchDifferences
{
    [CmdletBinding()]
    Param
    (
      [Parameter(Mandatory=$true, Position=0)]
      [string]$branch
    )
    
    git checkout master;
    
    $suffixForBranchName = "/CodeReview";
    
    $codeReviewBranchName = -join($branch, $suffixForBranchName);
    
    $existingTemporaryBranch = git branch --list $codeReviewBranchName;
    
    if ($existingTemporaryBranch -like "*$codeReviewBranchName") {
      git branch -D $codeReviewBranchName # Force delete the branch
    }
    
    git fetch origin;
    
    git checkout -b $codeReviewBranchName origin/master; # Create new branch
    
    $branchNameForMerge = -join("origin/", $branch);
    
    git merge $branchNameForMerge --no-commit --no-ff;
    
    Write-Host "Success!" -ForegroundColor Green;
}
