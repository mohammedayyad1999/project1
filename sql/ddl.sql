
/*
drop table  user_council;
drop table users;
drop table std_council;
drop table takes;
drop table lecture;
drop table student_phone;
drop table student;
drop table council;
drop function not_belong();
drop function lec_num_constrian();
*/


create schema religion_council;
set search_path to 'religion_council';

create table council(
council_name varchar(40)not null unique,
instructor varchar(40)not null,
topic varchar(30)not null,
book varchar(100),
def_place varchar(30)not null,
primary key (council_name)
);




create table student(
std_name varchar(50) not null,
living_area varchar(15),
primary key (std_name)
);

create table student_phone(
std_name varchar(50) not null,
phone varchar(50) unique,
primary key (std_name,phone),
foreign key (std_name) references student(std_name)
);

create table std_council(
std_name varchar(50) not null,
council_name varchar(40)not null,
primary key(std_name,council_name),
foreign key (std_name)references student(std_name),
foreign key (council_name)references council(council_name)
);

create table lecture(
council_name varchar(40)not null,
lec_number int not null,
lec_topic varchar(50)not null,
mosque varchar(50),
primary key (council_name,lec_number),
foreign key (council_name) references council(council_name)
);


create table takes(
std_name varchar(50) not null,
council_name varchar(40)not null,
lec_number int not null,
primary key(std_name,council_name,lec_number),
foreign key(std_name) references student(std_name),
foreign key(council_name,lec_number) references lecture(council_name,lec_number)
);


create table users(
user_name varchar(100) unique,
user_password varchar(50),
user_type varchar(100),
primary key(user_name)
);

create table user_council(
user_name varchar(100),
council_name varchar(50),
primary key (user_name,council_name),
foreign key (user_name)references users(user_name),
foreign key (council_name)references council(council_name)
);




--drop function lec_num_constrian();
create function lec_num_constrian()
returns trigger as
$m$
begin
	if exists ( 
	
		select * from 
		lecture l
		where l.lec_number = new.lec_number
		and l.council_name=new.council_name
		
		
	)
	then raise exception
	'an lecture cannot take two different number in the same council';
end if;
	return new;
end;
$m$
language 'plpgsql';

--drop trigger lec_num_constrian on lecture;
create trigger lec_num_constrian
before insert 
on lecture 
for each row
execute function lec_num_constrian();


--drop function not_belong();
create function not_belong()
returns trigger as
$m$
begin
	if not exists(
        select * 
        from council c  
		where c.council_name=new.council_name
		)
		then raise exception
	'the council dose not exist in council table ';
	elseif not exists(
        select * 
        from student s  
		where s.std_name = new.std_name
		)
		then raise exception
	'the student dose not exist in student table ';
	elseif not exists ( 
	    select * 
	    from std_council sc 
		where sc.std_name = new.std_name
		and sc.council_name=new.council_name
		
	)
	then raise exception
	'the student cant take licture because he dosnt enrolled in this council ';
end if;
	return new;
end;
$m$
language 'plpgsql';


create trigger not_belong
before insert or update 
on takes 
for each row
execute function not_belong();




