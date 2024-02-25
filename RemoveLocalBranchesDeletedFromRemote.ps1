# This function will delete any local branches that have already been deleted from the origin

function RemoveLocalBranchesDeletedFromRemote 
{
    git fetch -p | git branch -vv | Select-String -Pattern ": gone\]" | ForEach-Object { $_.ToString().Split()[2] } | ForEach-Object { git branch -D $_ }
}
