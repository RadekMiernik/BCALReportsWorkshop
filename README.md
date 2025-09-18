## Table of content
- [BC/AL Reports Workshop](#bcal-reports-workshop)
- [Word layouts](#word-layouts)
  - [Before you start](#before-you-start)
  - [General](#general)
  - [Case 1 - customer address modification on standard invoice](#case-1---customer-address-modification-on-standard-invoice)
  - [Case 3 - barcode with the document number on the header](#case-3---barcode-with-the-document-number-on-the-header)
  - [Case 4 - item picture on the line for sales order](#case-4---item-picture-on-the-line-for-sales-order)
  - [Case 5 - special notes added when needed](#case-5---special-notes-added-when-needed)
    - [Useful information](#useful-information)
  
# BC/AL Reports Workshop

Repository with code, layouts and examples, that might be useful if you want to upgrade your reports that you can create in the Business Central.

# Word layouts

## Before you start 
Here you find a list of things that you need to consider (or agree with the customer) before you even start working on the layout.

- what is the size of the paper
- what are margins
- are there special needs about header and footer
- what is expected size of each area (for example columns)
- what are their values in the system that later will be shown on the report 
- does customer need easy access to update specific label in the layout
- does customer need a dictionary of something that might be used in the future
- does customer need a barcode - if yes - good to have some examples prepared before to decide which should be used. Really important if they use some digital readers
- what if there is no lines to show on the report

## General

1General Word report to explain and have a possibility to play around with the code to see the behaviour of the code and what result it brings.

Report is using **Integer** table to create number of dataitem as needed. So no data in the system is mandatory.

Keep in mind that layout is not formatted in a perfect way. The main purpose of that layout is to show how the structure of the data might impact on the final printout.

There is also an Excel layout. Data prepared for Word layout is not a perfect fit for Excel layouts, but thanks to that it is easy to show, that the same code can support both needs - having a printable document, and data for later analysis.

## Case 1 - customer address modification on standard invoice

The customer wants to have a value from **Pre Assigned** field exactly below the customer address on the printout.

We need to extend existing report and apply new layout to the solution. 

The customer wants also define that specific layout as a default one.

## Case 3 - barcode with the document number on the header

## Case 4 - item picture on the line for sales order

Customer wants to have an item picture on the line generated on the standard report for purchase order.

We need to extend existing report and apply new layout to the solution. 

The customer wants also define that specific layout as a default one.

## Case 5 - special notes added when needed



### Useful information

Helpful page if you work with barcodes: https://www.idautomation.com/barcode-fonts/#High_Density_Fonts
