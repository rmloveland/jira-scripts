README
======

This is a collection of scripts that do stuff to JIRA.  They're
written in Perl, but it shouldn't matter; each script has been
"packed" as a single file with all its dependencies.  The packed
versions of the scripts are in the `out` directory.

They use your `.netrc` file for logins.  Right now they're hardcoded
to point to `jira.corp.appnexus.com`, but that should probably be
changed to use the .netrc.

Here are the scripts; see below for examples of their use.

+ `jira-create-issue`
+ `jira-add-comment`
+ `jira-search-issues`
+ `jira-set-issue-status`


Examples
--------

*Create an Issue*

Type this to create an issue with this title in the `DOC` queue:

    $ jira-create-issue DOC 'Update Frobnitz wiki page'

Then this script pops up `$EDITOR` to write a longer description.
It's pretty nice with `vim` or `emacsclient`, but it shouldn't matter.

*Comment on an Issue*

Add a comment like so:

    $ jira-add-comment DOC-123

This pops open `$EDITOR` to edit your comment.

*Search Issues*

The output of `jira-search-issues` is pretty dumb (just raw JSON).
It's not too hard to make it useful, though.  Here's an example using
it to print out all of your current work.  You need
[`jq`](http://stedolan.github.io/jq/) for this (you probably already
have `sed`):

    $ jira-search-issues "assignee = rloveland AND status not in (Closed, Resolved) ORDER BY status" \
    | jq '.key + " " + .fields.summary' | sed -e 's/\"//g';

	PF-3260 Document new Bulk Create Bid screen
	DOC-867 Best practices for presenting information visually
	MS-784 Docs: Update AdTrace / Pitbull / Insight wiki page with potential gotchas
	MS-774 Document ANAdDelegate AdListener calls
	DOC-1310 Web passbacks
	DOC-1304 Data Leakage Protection (MSFT)
	DOC-1320 SSP: Mediated Bid Optimization (Estimated CPM Revenue Type)
	DOC-1306 Block flash creatives w/o backup images (MSFT)
	DOC-1307 Automated Optimal Floors
	DOC-1337 SSP: Bid \tagging\ and filtering
	DOC-1504 New KB Article - Transactional Reporting Options
	DOC-1259 AdX Creative Audit Status Sync
	DOC-852 [S] Update Ad Profile Service doc to include information on retrieving by mappings
	PDM-151 Write client-facing docs for passback
	DOC-1659 Multiple fields removed from mobile reporting, wiki's not updated
	DOC-457 [M] Mobile device analytics and targeting caveats
	DOC-1627 Update all API usage examples to use https

*Set an Issue's Status*

JIRA has some weird, arbitrary status codes.  There are a few useful
ones in the help output from the script:

	~/work/code/jira-scripts $ jira-set-issue-status 
	Usage: jira-set-issue-status ISSUE STATUS_ID

	Try one of these:

	| STATUS_ID | Meaning             |
	|-----------+---------------------|
	|        11 | 'Start Progress'    |
	|       141 | 'Start Code Review' |
	|       161 | 'Blocked'           |
	|       171 | 'Close'             |
	|       191 | 'Testing'           |

In other words, just type something like this:

    $ jira-set-issue-status DOC-123 191
