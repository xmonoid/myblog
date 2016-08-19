--
-- Create the database and connect to it.
connect 'jdbc:derby://localhost:1527/myblog;create=true';

-- Add a user to the database, username myroot, password myroot
call syscs_util.syscs_set_database_property('derby.user.myroot','myroot');

-- Grant all privileges to user myroot
call syscs_util.syscs_set_database_property('derby.database.fullAccessUsers','myroot');

-- Disconnect from the newly created database
disconnect;

-- Reconnect to the newly created database as user myroot
connect 'jdbc:derby://localhost:1527/myblog;user=myroot;password=myroot';

create table articles (
    article_id int not null primary key,
    title varchar(120) not null, -- the header
    content clob not null, -- the text content
    dttm timestamp not null default current_timestamp -- the date and time of the new article
);

create table groupusers (
    groupuser_name varchar(60) not null primary key -- the name of the group
);

create table groupuser_has_articles (
    groupuser_name varchar(60) not null references groupusers(groupuser_name),
    article_id int not null references articles(article_id),
    unique (groupuser_name, article_id)
);

create table users (
    login varchar(60) not null primary key, -- login
    password varchar(60) not null, -- passowrd
    groupuser_name varchar(60) not null references groupusers(groupuser_name)
);

create table messages (
    message_id int not null primary key,
    message_text varchar(255) not null, -- the text of the message
    dttm timestamp not null default current_timestamp, -- the date and time of the message
    login varchar(60) not null references users(login), -- the user who sent the message
    article_id int not null references articles(article_id) -- the article which was commented
);