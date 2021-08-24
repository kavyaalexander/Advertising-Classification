/*1) Load data*/

proc import datafile='/home/u59058987/Dataset/advertising_classification.csv' out=Advertising dbms=csv replace;
getnames=yes;
run;
proc print data=Advertising;
run;

/*2)Summary and information of dataset*/
proc contents data=Advertising;
run;

/*3)Print top 10 rows in the dataset */

proc print data=Advertising(obs=10);
    
run;

/*4)How many of them are clicked on ad or not*/

proc sql;
select sum(Clicked_on_Ad) from advertising where Clicked_on_Ad=1;
quit;
/*After analysing the dataset of 1000 rows, half of the users are clicked on ads & not clicked on ads*/

/*5)Show clicked on ad or not in pie chart */

proc template;
	define statgraph pie;
		begingraph;
		entrytitle "Clicked on ad or not";
		layout region;
		piechart category=Clicked_on_Ad /;
		endlayout;
		endgraph;
	end;
run;

proc sgrender template=pie data=WORK.ADVERTISING;
run;

/*6) Show gender column in bar chart*/

proc sgplot data=WORK.ADVERTISING;
	title "Gender";
	vbar Gender / fillattrs=(color=red);
	yaxis grid;
run;

title;


/*7)Analyse click on ad  with gender by using bar chart*/

proc sgplot data=WORK.ADVERTISING;
	vbar Gender / group=Clicked_on_Ad groupdisplay=cluster;
	yaxis grid;
run;

/*Most of the female customers are click on ad
& Male customers are not click on ad*/

/*8)Find female customers click on ad and her age <35*/

data adv1;
set ADVERTISING;

if Gender=0 & Clicked_on_Ad=1 & Age<35;
run;

proc print data=adv1;
run;

/*9)Find male customer not click on ad and age <35*/
data adv;
set ADVERTISING;

if Gender=1 & Clicked_on_Ad=0 & Age<35;
run;

proc print data=adv;
run;

/*10) Find customers having more than 60000 Area Income & click on ad*/
proc sql;
select * from advertising where Area_Income>70000 & Clicked_on_Ad=1;
quit;

/*11)Show daily internet usage in histogram */

proc sgplot data=WORK.ADVERTISING;
	histogram Daily_Internet_Usage /;
	yaxis grid;
run;

/*12) Analyse Daily_Internet_Usage with clicked on ad*/

proc sql;
select Daily_Internet_Usage,Clicked_on_Ad from advertising where Clicked_on_Ad=1;
quit;

/*13)Analyse the city with click on Ad*/

proc sql;
select Daily_Internet_Usage,City,Clicked_on_Ad from advertising where Clicked_on_Ad=1;
quit;

/*14)Analyse the Ad_Topic_Line with click on Ad	*/

proc sql;
select Ad_Topic_Line,Daily_Internet_Usage,City,Clicked_on_Ad from advertising where Clicked_on_Ad=1;
quit;

proc freq data=advertising;
tables Ad_Topic_Line*Clicked_on_Ad /nocum nopercent plots=freqplot(twoway=stacked orient=horizontal);
where Clicked_on_Ad=1
and Gender =1 and Age>35;
run;


