## This function will create a new branch with a branch from remote and append /CodeReview to it

function GetBranchDifferences
{
    [CmdletBinding()]
    Param
    (
      [Parameter(Mandatory=$true, Position=0)]
      [string]$branch
    )
    
    git checkout master;
    
    $prefixForBranchName = "refs/heads/";
    $suffixForBranchName = "/CodeReview";
    
    $codeReviewBranchName = -join($branch, $suffixForBranchName);
    
    $existingTemporaryBranch = git for-each-ref --format='%(refname:short)' branch --list $codeReviewBranchName;
    
    if ($existingTemporaryBranch -like "*$codeReviewBranchName") {
      git branch -D $codeReviewBranchName # Force delete the branch
    }
    
    git fetch origin;
    
    git checkout -b $codeReviewBranchName origin/master; # Create new branch
    
    $branchNameForMerge = -join("origin/", $branch);
    
    git merge $branchNameForMerge --no-commit --no-ff;
    
    Write-Host "Success!" -ForegroundColor Green;
}

function CleanupBranches
{
	git checkout master;
	$branches = git for-each-ref --format='%(refname:short)' 'refs/heads/**/CodeReview';
	Foreach ($branch in $branches) 
	{
		if ($branch -like "*/CodeReview")
		{
			git branch -D $branch;
		}
	}
}
