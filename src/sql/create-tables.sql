create table users (
  id         uuid primary key,
  name       varchar(80) not null,
  e_mail     varchar(300) not null,
  created_at timestamp not null,
  unique(name, e_mail)
);

create index users_name_idx on users(name);
create index users_e_mail_idx on users(e_mail);

create table downloads (
  id            uuid primary key,
  user_id       uuid references users(id) on delete cascade not null,
  created_at    timestamp not null,
  downloaded_at timestamp
);

create index downloads_created_at_idx on downloads(created_at);
create index downloads_downloaded_at_idx on downloads(downloaded_at);
