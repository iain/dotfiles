function aws-profile-switch -a profile
  if aws configure list-profiles | grep -q $profile
    set account_id (aws sts get-caller-identity --profile $profile --output text --query Account)
    if test $status = 0
      set -gx AWS_PROFILE $profile
      echo "Current account id is: $account_id"
    else
      aws sso login --profile $profile
      set -gx AWS_PROFILE $profile
      set account_id (aws sts get-caller-identity --profile $profile --output text --query Account)
      echo "Current account id is: $account_id"
    end
  else
    echo "Unknown profile: $profile"
    return 1
  end
end
