# Table of Contents

 1. `ledgervim.vim`
 2. `DownloadingFiles.sh`
 3. the `visualizing/` directory
 4. `HLedgerImport.sh`
 5. `BulkImport.sh`

# `ledgervim.vim`

Nowadays, I use `evil-mode` and `ledger-mode` on the spacemacs implementation of `emacs`, but I used to edit my ledger journals in vim with the [`vim-ledger`](https://github.com/ledger/vim-ledger) plugin.  This vimscript helped me by adding some custom functionality to `vim-ledger`.

# `DownloadingFiles.sh`

This script is meant to be run in your `~/Downloads/` directory.  As you download csv data and pdf files from your bank, you can run this script to move these files to appopriate locations in the directory structure shown below.

The script is called as `source /path/to/DownloadingFiles.sh`.  (Setting an alias is recommended).  The possible arguments are

 * `cm` to change the month.  By default, the month is set to the one prior to this month
 * `ca` to change account.  You can choose any of the accounts configured it `$acct_options` below
 * `ck` to check your downloads.  This prints a table of all your banks and indicates whether you have yet downloaded csv's
    and statements for each.
 * (any `.csv` or `.pdf`) filename to move that file to the appropriate folder in the directory structure shown below.  All
    pdf's get saved as `s-bank_name-00.pdf`.  All csv's get saved as `c-bank_name-00.csv`, and an entry is made into 
    `to-import.txt`, which will be used by `BulkImport.sh`.

## Configuration

There are two lines in this file that need to be configured.  
  * The array `$acct_options` should include any bank that you run this data on.
  * The path to where you will store this data needs to be enterd at `$path_to_finances`.  *It is important 
    to include the closing '/'.*  It is assumed that this path will lead to a directory structure broken down by month
    as shown below

      data/ (this directory is set in config.sh as $path_to_finanaces)
        |
        +---01 (for January data)
        |
        +---02 (for February data)
        |
        .
        .
        .
        |
        +---12 (for December data)

# The `visualizing/` directory

I started by copying all the scripts from [this page](https://www.sundialdreams.com/report-scripts-for-ledger-cli-with-gnuplot/)
that I found out about via [plaintextaccounting.org](https://www.plaintextaccounting.org).  These are all in the `visualizing/from_sundiandreams` folder.  I used these as a jumping-off point to write my own `expenses_by_source_monthly.sh`, `food.sh` (for tracking restaraunt vs. grocery spending!), and `income_expenses.sh`.

# `HLedgerImport.sh`

This script uses `hledger`'s `print` command to import a csv into ledger format.  It makes use of the rules files stored in `hledger-rules/`.

This is the least usable (and, unfortunately, most central) script of this whole project.  I wanted to strip out any personal
bank identifying info in all these scripts.  Unfortunately, that effectively neuters this script.  

Here's what you'd need to do to make this script useable:

 1. Update `hledger-rules/bank-1.csv.rules` to match the csv format of your bank.  Copy this document for any other banks you may have.
 2. copy the `if` statements in `HLedgerImport.sh` to match all of the the rules files you just made.

I realize this is incredibly inefficient, but it is what it is right now!

# `BulkImport.sh`
This script calls `HLedgerImport` for all files listed in a `to-import.txt` file whose entries are created using `DownloadingFiles.sh` above.  This is run as `./BulkImport.sh /path/to/to-import.txt`.
