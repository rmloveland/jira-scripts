README
======

This is a collection of Perl scripts that take care of my basic JIRA needs:

+ Create an issue
+ Comment on the issue
+ Bump the issue's status (a.k.a., transition)
+ Close the issue (via transitions)
+ Search all the issues with JQL

Using these scripts, you can (probably?) completely avoid JIRA's web interface if you want.


Installation
------------

1. Clone it.
2. Fire up `cpan` (Perl's package manager) in your terminal to get [ONE LIBRARY](https://metacpan.org/pod/JIRA::REST) for interacting with JIRA.  If the `cpan` client prompts you for things, just keep hitting ENTER to accept the defaults.  Sorry about this; dynlang package managers are kinda annoying.  (If someone can show me how to distribute this as a single concatenated ball of code, I'd be happy to.  I tried [App::FatPacker](https://metacpan.org/pod/App::FatPacker) but couldn't make it work.)

        $ cpan JIRA::REST
        ... stuff ...

3. Make sure your JIRA credentials are in your `.netrc` file, e.g.,

        machine https://jira.corp.appnexus.com
        login rloveland
        password SECRET

4. Link as many or as few of these as you want into your `~/bin`:
	+ `jira-search-issues`
	+ `jira-set-issue-status`
	+ `jira-add-comment`
	+ `jira-create-issue`

5. To see usage info for each script, call it with no arguments:

        $ jira-add-comment
        Usage: jira-add-comment ISSUE


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
