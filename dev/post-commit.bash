set -e
unset GIT_DIR
if [[ -z "${SKIP_POST_COMMIT}" ]]; then
	echo Done 
else
	echo including pre-commit change on perfs
	SKIP_POST_COMMIT=true git commit perfs --amend --no-verify --no-edit
	
fi

