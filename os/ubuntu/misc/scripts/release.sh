#!/bin/bash


RELEASE_VERSION=$1
RELEASE_TICKET_DIR=issues
PARENT_BRANCH=master
FEATURE_BRANCH_PREFIX=feature
RELEASE_BRANCH_PREFIX=release


if [[ -z $RELEASE_VERSION ]]; then
    echo "release branch publisher"
    echo "usage: $0 [RELEASE_VERSION]";

else

    RELEASE_ITEM_LIST=$RELEASE_TICKET_DIR/$RELEASE_VERSION
    RELEASE_BRANCH=$RELEASE_BRANCH_PREFIX/$RELEASE_VERSION

    if [[ -f "$RELEASE_ITEM_LIST" ]]; then

        echo "create release branch -> $RELEASE_BRANCH" > $0.log

        git branch -D $RELEASE_BRANCH

        echo
        echo "> git checkout -b $PARENT_BRANCH $RELEASE_BRANCH"
        git checkout -b $RELEASE_BRANCH $PARENT_BRANCH

        echo
        echo "> git checkout $RELEASE_BRANCH"
        git checkout $RELEASE_BRANCH

        TICKET_LIST=$(cat $RELEASE_ITEM_LIST)

        for TICKET in $TICKET_LIST; do

            git branch -D $FEATURE_BRANCH_PREFIX/$TICKET

            git checkout $FEATURE_BRANCH_PREFIX/$TICKET
            git checkout $RELEASE_BRANCH

            echo
            echo "> git merge --no-ff $FEATURE_BRANCH_PREFIX/$TICKET"
            echo ">     -m \"merge $FEATURE_BRANCH_PREFIX/$TICKET to $RELEASE_BRANCH\""
            git merge --no-ff $FEATURE_BRANCH_PREFIX/$TICKET \
                -m "merge $FEATURE_BRANCH_PREFIX/$TICKET to $RELEASE_BRANCH"

            if [ $? != 0 ]; then

                echo "!!! failed to merge $FEATURE_BRANCH_PREFIX/$TICKET to $RELEASE_BRANCH" >> $0.log
                git status | grep "both" >> $0.log
                echo "" >> $0.log

                echo
                echo "> git merge --abort"
                git merge --abort
            else
                echo "    success to merge $FEATURE_BRANCH_PREFIX/$TICKET to $RELEASE_BRANCH" >> $0.log
                echo "" >> $0.log
            fi
        done

        VERSION_MAJOR=$(echo $RELEASE_VERSION | cut -f1 -d ".")
        VERSION_MINOR=$(echo $RELEASE_VERSION | cut -f2 -d ".")
        VERSION_PATCH=$(echo $RELEASE_VERSION | cut -f3 -d ".")

        git commit -am "change version to $VERSION_MAJOR.$VERSION_MINOR.$VERSION_PATCH"

        echo "done" >> $0.log
        echo "ready to publish. check git worklog ($0.log)"

    else
        echo "release list $RELEASE_VERSION does not exists"

    fi;
fi;
