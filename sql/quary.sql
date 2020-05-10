select std_name ,(count(*)+0.0)/(select count(*)from lecture where council_name='Чснох')from takes natural join lecture where council_name='Чснох'
group by std_name
having ((count(*)+0.0)/(select count(*)from lecture where council_name='Чснох'))>=0.9;


select lec_number,lec_topic ,concat((count(*)+0.0)/(select count(*)from lecture where council_name='Чснох')*100,'%')as attend from takes natural join lecture where council_name='Чснох'
group by 1,2
order by 3 desc
limit 10;

