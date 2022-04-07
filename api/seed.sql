pragma foreign_keys = yes;

DROP TRIGGER IF EXISTS calculate_total_delete;
DROP TRIGGER IF EXISTS calculate_total_insert;

DROP TABLE IF EXISTS transaction_items;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS items;


CREATE TABLE users
(
    uuid          text primary key,
    name          text(50)   not null,
    email         text       not null unique,
    password      text       not null default '$2a$10$SRS/4JMQIqIFUJc2WjWOWe9h8mvV1nm.36gl76KVZfgq6CGypu9se',
    vat           integer(9) not null unique,
    address       text(100)  not null,
    card_number   numeric    not null,
    card_validity text       not null,
    card_type     text       not null,
    public_key    text       not null unique
);

create table items
(
    uuid        text primary key,
    name        text    not null,
    description text    not null,
    barcode     numeric not null unique,
    make        text    not null,
    price       numeric not null
);

create table "transactions"
(
    uuid        text primary key,
    token       text unique not null,
    total_price numeric     not null default 0,
    timestamp   timestamp   not null default (datetime('now','localtime')),
    user_uuid   text     not null,
    token_valid boolean  not null default true,
    constraint user_fk foreign key (user_uuid) references users (uuid) on delete cascade
);

create table transaction_items
(
    id               integer primary key autoincrement,
    transaction_uuid text not null,
    item_uuid        text not null,
    constraint tr_fk foreign key (transaction_uuid) references transactions (uuid) on delete cascade,
    constraint item_fk foreign key (item_uuid) references items (uuid) on delete cascade
);

CREATE TRIGGER IF NOT EXISTS calculate_total_insert
    AFTER INSERT ON transaction_items
BEGIN
    UPDATE transactions
    SET total_price = round(
        (SELECT sum(price)
        from items, transaction_items
        where items.uuid = transaction_items.item_uuid AND transaction_items.transaction_uuid = new.transaction_uuid), 2)
    WHERE transactions.uuid = new.transaction_uuid;
end;

CREATE TRIGGER IF NOT EXISTS calculate_total_delete
    AFTER DELETE ON transaction_items
BEGIN
    UPDATE transactions
    SET total_price = round(
            (SELECT sum(price)
             from items, transaction_items
             where items.uuid = transaction_items.item_uuid AND transaction_items.transaction_uuid = old.transaction_uuid), 2)
    WHERE transactions.uuid = old.transaction_uuid;
end;


insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (1, 'Marketa Hardwin', 214883525, '8044 Mandrake Center', 'mhardwin0@nydailynews.com', '4017959739229326', 'visa', '4/22', '1AfXYBYtTKbz7zs6FBJSXyMKRkvSmN19BC');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (2, 'Felicio Delaprelle', 421759553, '07 Lillian Way', 'fdelaprelle1@timesonline.co.uk', '5108753131922696', 'mastercard', '10/22', '14hW32XuigjZemm2y3qmi73waDu7TetHo3');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (3, 'Stan Orsman', 834075790, '6740 Garrison Avenue', 'sorsman2@gov.uk', '5293145125727980', 'mastercard', '4/22', '18APBVbNBbd4bK5NqK7cdr9aLM5kVSCX8d');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (4, 'Bondie Dumbell', 681578991, '238 Truax Park', 'bdumbell3@wikispaces.com', '4041593577513', 'visa', '10/22', '17snUqvufRHaU2DkKU73eLegk9boLpMEi6');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (5, 'Gerik Lyddiatt', 245126813, '93644 Ronald Regan Terrace', 'glyddiatt4@slate.com', '4041595454257', 'visa', '4/22', '1Eggiwg7Uxvvmt2zU8WCztcs9itG1TB7BW');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (6, 'Caro Storks', 906259462, '4620 Tennyson Street', 'cstorks5@pagesperso-orange.fr', '4017953953595140', 'visa', '5/23', '13g8vSvZTSMnU9SbZv71FioapyrrKEkQUJ');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (7, 'Laurella Folland', 452321908, '0 Bluejay Lane', 'lfolland6@washingtonpost.com', '5108753801754817', 'mastercard', '4/22', '19Am24bvScY8PxK8riLnCqnGQ1GrPHAJfj');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (8, 'Michel McPhilip', 569620623, '523 Sutherland Point', 'mmcphilip7@dion.ne.jp', '4017953920275776', 'visa', '10/22', '17NB3uFEh8nycBT81UatJ5TxxdfhrZyDUq');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (9, 'Hamish Yuryichev', 510284768, '92 Ruskin Avenue', 'hyuryichev8@ucoz.ru', '5433432061071487', 'mastercard', '5/23', '162sC4K9rJ8FhmsuRDB3LDEW8yG4F3kDkA');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (10, 'Joelly Valentinuzzi', 609821196, '2599 Manitowish Hill', 'jvalentinuzzi9@vistaprint.com', '5108759163878797', 'mastercard', '5/23', '18wFHr1f1KjMqoayftuWqA11Gk8xR7Sd1h');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (11, 'Valerie Jedrzejewski', 961506592, '13 Doe Crossing Street', 'vjedrzejewskia@deliciousdays.com', '5145791339668138', 'mastercard', '4/22', '1CwuLvbRtqjrcm8PGjht8AfHNbg7cDbB5c');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (12, 'Letisha Dieton', 945170565, '6 Quincy Road', 'ldietonb@telegraph.co.uk', '5100147299502531', 'mastercard', '10/22', '1x7rGKQ4GMcJrn5753BqQ3UVh7yb18K9j');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (13, 'Zachary Maddicks', 465136193, '76903 Garrison Street', 'zmaddicksc@mashable.com', '5002356408661919', 'mastercard', '10/22', '15UUjY1d8tExeYXbtSEsW9zJUXiFe47qbT');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (14, 'Anatol Burberow', 812496907, '11 Muir Way', 'aburberowd@stanford.edu', '4017959438086', 'visa', '4/22', '18Bis7rAmSaFNpG7Sc4aD7jmFuzs8t3Y6U');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (15, 'Zerk Southerill', 428545981, '67 Elmside Street', 'zsoutherille@phpbb.com', '5405112673822584', 'mastercard', '10/22', '12UiGuirenCTYUX6DVBqNHGh1nhLvGTYRF');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (16, 'Tallia Pudner', 485520138, '43 Kenwood Street', 'tpudnerf@ucoz.com', '5002352907575965', 'mastercard', '5/23', '12hrstvX3FzhoH2DCYoVuUKQ4bkM1CBbMQ');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (17, 'Dillon Ajam', 301131862, '99793 Blue Bill Park Way', 'dajamg@google.com.br', '4041377525969486', 'visa', '5/23', '1A3xApn63VRaSK23UmcA6JE32XcQMxTkW8');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (18, 'Alysia Tuxill', 823688972, '01163 Carioca Road', 'atuxillh@opera.com', '4041379741630', 'visa', '4/22', '17JHqfRMGkqwBJxm585SisLsxujj9CkMKw');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (19, 'Elinor Hazelhurst', 472882556, '542 Pond Plaza', 'ehazelhursti@wisc.edu', '5007666129333456', 'mastercard', '4/22', '1FbzZR558utd1K66b4hwzrSa2Xu2rp5c1y');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (20, 'Arvin Dimic', 403724506, '656 Logan Road', 'adimicj@jiathis.com', '4017951626241', 'visa', '10/22', '1EwFw7MZX397HDP4wLieaHwFEn7oTn99ap');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (21, 'Douglass Gregoire', 441482144, '459 Evergreen Park', 'dgregoirek@over-blog.com', '5010123256714228', 'mastercard', '10/22', '1PTHzgdivDUNfLBgqa14awGdPQQPJ4yixp');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (22, 'Tildi Lacaze', 751522590, '06 Holy Cross Hill', 'tlacazel@google.de', '5100174084843052', 'mastercard', '5/23', '16gBHZGJj5JpaDn6XzWn9KQR2SqZ83vHu3');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (23, 'Hale Greenall', 642746715, '4466 Monica Avenue', 'hgreenallm@wufoo.com', '4041593337630765', 'visa', '10/22', '1NbE8rqCGBjQ218xPsyfRgDTNFQjyP4y3z');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (24, 'Kort Sopper', 673490555, '28018 Artisan Street', 'ksoppern@cornell.edu', '5456000847838503', 'mastercard', '4/22', '1PkebsU5E6a8waw28meczmc32Y192rSizR');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (25, 'Mack Kimbrough', 549880843, '01 Montana Trail', 'mkimbrougho@globo.com', '4017959147356', 'visa', '4/22', '1EbJqLQFNwgRW2NhNT2fohyKd1QWkMBpVp');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (26, 'Dian Genney', 867671207, '72 Elmside Lane', 'dgenneyp@cbc.ca', '4041370644189', 'visa', '10/22', '1PAmvLFa94hbVhjY7UVzvD5Zk3q9jnD7eo');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (27, 'Ruperta Shepland', 761494067, '8 Brown Circle', 'rsheplandq@dion.ne.jp', '5100136761846187', 'mastercard', '10/22', '1FpBi5BRRuY1A5ShYkKD3URjAL6w4oYXkV');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (28, 'Deane Makiver', 930221559, '737 Messerschmidt Road', 'dmakiverr@freewebs.com', '4041374029718', 'visa', '10/22', '1GR97kZqj4EcuDDCLqB4J1DWvk7VpVeSVp');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (29, 'Rivy Swepstone', 729622765, '19 Del Mar Way', 'rswepstones@godaddy.com', '5007662448759844', 'mastercard', '5/23', '139uQQnuSYVBuFjayVwFPVE3ErNd7WVdr1');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (30, 'Cherilynn Tremblot', 831656770, '84717 Leroy Way', 'ctremblott@elpais.com', '4852420287621438', 'visa', '10/22', '18Vc6wHRaybg5ApnjkAt2k5PvNurxEkrrg');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (31, 'Dede MacCosty', 854289755, '75 Green Pass', 'dmaccostyu@free.fr', '4017951037803', 'visa', '10/22', '17LmBfHaAYgXDLwkeG8Nsb3Dj1KPnW2vLD');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (32, 'Torrance Pargent', 478170115, '73901 Portage Alley', 'tpargentv@springer.com', '4041376501201', 'visa', '5/23', '12bX94t69ZUitQHhjBNF54TgBxQtGAUp8K');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (33, 'Baxie Drackford', 377397386, '3 Judy Road', 'bdrackfordw@free.fr', '5295561773161454', 'mastercard', '5/23', '17hvHn4AtGam3WrQUK2F9ezKb9rb7J6Qkq');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (34, 'Zulema Ouldcott', 209126496, '249 Macpherson Avenue', 'zouldcottx@icq.com', '5100138418581217', 'mastercard', '5/23', '13Uieo9wc23xRYRWPS3h2dndLjVhXszRt7');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (35, 'Hendrick Roggero', 909060776, '631 Bellgrove Terrace', 'hroggeroy@hostgator.com', '4309011218642', 'visa', '5/23', '1QGbZgnwrHTKWv12kYX9D66mAYWsC5CB2m');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (36, 'Fin Dobrowlski', 986192370, '5 Elka Trail', 'fdobrowlskiz@tripod.com', '5180590244481348', 'mastercard', '10/22', '165D8iPWgPqUMFpmeXfvBMEFhvLkfSm3Yy');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (37, 'Temple Gaylard', 161003885, '1 Melvin Pass', 'tgaylard10@ed.gov', '4041375506061836', 'visa', '4/22', '1LJmBF13Mtbv77vAq9D6XQtBgNmMZuk1yD');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (38, 'Melissa Machan', 373059052, '6355 Mayer Way', 'mmachan11@whitehouse.gov', '4041594184169352', 'visa', '4/22', '17XrtGjH6ne6HKnaRDaDw4VxTuCBHs5nQL');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (39, 'Borden Suatt', 265178547, '9522 Buena Vista Road', 'bsuatt12@cyberchimps.com', '5108756589056339', 'mastercard', '10/22', '1J9FqK5GQz7ddCwweCdPTbZuLS6ndDBWAd');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (40, 'Moises Sheivels', 480371198, '4290 Everett Lane', 'msheivels13@whitehouse.gov', '4017952525541', 'visa', '5/23', '16uEuqz2uzNXLvGAa7nHh8g16CgAduCRoG');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (41, 'Darleen Allchorn', 206552947, '4 American Pass', 'dallchorn14@skype.com', '5578938369302270', 'mastercard', '4/22', '14E9zSDoXf1g9JhVjjx68SQv6dV4GngyzH');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (42, 'Adriena Matushevitz', 488801836, '2089 Nevada Hill', 'amatushevitz15@nymag.com', '5007665673759272', 'mastercard', '10/22', '1BEBkVohmZcGCzKuh97YvrHXbuF3g5FHGF');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (43, 'Lilith Norris', 852713671, '0598 Mayfield Way', 'lnorris16@ucoz.ru', '5010125215807860', 'mastercard', '10/22', '1GVJg1uGTdatLqKYe5ibSKNvLFDvrtSsuN');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (44, 'Susana Slemming', 611671068, '89 Mayer Hill', 'sslemming17@example.com', '5364670032469909', 'mastercard', '10/22', '1CPfymFBxyWbPmna3X1VsokMgRn6bGk978');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (45, 'Dill Dayes', 202576545, '70522 Melody Place', 'ddayes18@deliciousdays.com', '5007669361103074', 'mastercard', '5/23', '13orBFXQB6tvMVvzeS4z5DmnJRVVDKijTb');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (46, 'Amalie Gotter', 216513609, '105 Dryden Trail', 'agotter19@squidoo.com', '4041374435246', 'visa', '5/23', '1CpFHCcyrpcu6Z6c2cubmLy1ZYE35nTWr4');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (47, 'Bathsheba Cakes', 449617704, '9 Tony Place', 'bcakes1a@whitehouse.gov', '4017952076891', 'visa', '4/22', '1Crue3GYmGSiXuWBJ7oZNtwS7KfSPisH7a');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (48, 'Kerk Leist', 210198348, '986 Buena Vista Trail', 'kleist1b@dropbox.com', '5100140738927567', 'mastercard', '10/22', '1AQVhFavdNmwUVoV3BfLSD26AWw3VwKDJr');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (49, 'Sunny Pardew', 907155967, '4 Almo Plaza', 'spardew1c@dailymail.co.uk', '4386026787050', 'visa', '5/23', '1HyYHih4vfgNZEusPyHX7JN5ZLP7xUgB98');
insert into users (uuid, name, vat, address, email, card_number, card_type, card_validity, public_key) values (50, 'Sofie Swayland', 935102540, '4841 Daystar Way', 'sswayland1d@unicef.org', '5048379681013414', 'mastercard', '4/22', '1Lp81NRcRepL3kVcZJMiqih2B8GVUtEfF8');

insert into items (uuid, name, description, barcode, price, make) values (1, 'Cheese - Parmesan Grated', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 60757331992, 40.66, 'ligula');
insert into items (uuid, name, description, barcode, price, make) values (2, 'Chicken - Whole Roasting', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 86482146779, 2.34, 'vulputate');
insert into items (uuid, name, description, barcode, price, make) values (3, 'Ranchero - Primerba, Paste', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 19492408305, 46.53, 'cum');
insert into items (uuid, name, description, barcode, price, make) values (4, 'Cape Capensis - Fillet', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 64855204205, 41.91, 'ac');
insert into items (uuid, name, description, barcode, price, make) values (5, 'Muffin Batt - Carrot Spice', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 29568853547, 13.23, 'congue');
insert into items (uuid, name, description, barcode, price, make) values (6, 'Fish - Artic Char, Cold Smoked', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 36492496247, 18.58, 'rhoncus');
insert into items (uuid, name, description, barcode, price, make) values (7, 'Wine - Cotes Du Rhone Parallele', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 21076450978, 24.71, 'cum');
insert into items (uuid, name, description, barcode, price, make) values (8, 'Soup - Campbells, Minestrone', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 19074207160, 19.84, 'duis');
insert into items (uuid, name, description, barcode, price, make) values (9, 'Lamb - Shoulder', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 26006393060, 9.35, 'vestibulum');
insert into items (uuid, name, description, barcode, price, make) values (10, 'Wiberg Super Cure', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 58352976789, 31.54, 'id');
insert into items (uuid, name, description, barcode, price, make) values (11, 'Tomatoes - Cherry', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 17768535997, 38.12, 'pede');
insert into items (uuid, name, description, barcode, price, make) values (12, 'Vol Au Vents', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 84673894684, 26.25, 'sapien');
insert into items (uuid, name, description, barcode, price, make) values (13, 'Cauliflower', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 87810545269, 3.12, 'pellentesque');
insert into items (uuid, name, description, barcode, price, make) values (14, 'Soup - Base Broth Beef', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 27381419389, 1.84, 'primis');
insert into items (uuid, name, description, barcode, price, make) values (15, 'Sausage - Liver', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 25683752679, 13.02, 'suspendisse');
insert into items (uuid, name, description, barcode, price, make) values (16, 'Crab - Blue, Frozen', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 10549348655, 47.18, 'aliquet');
insert into items (uuid, name, description, barcode, price, make) values (17, 'Sauce - Bernaise, Mix', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 34479411907, 41.27, 'orci');
insert into items (uuid, name, description, barcode, price, make) values (18, 'Pants Custom Dry Clean', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 99066579646, 1.64, 'eu');
insert into items (uuid, name, description, barcode, price, make) values (19, 'Tomato Paste', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 22585628491, 22.72, 'varius');
insert into items (uuid, name, description, barcode, price, make) values (20, 'Bok Choy - Baby', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 75375404445, 44.44, 'amet');
insert into items (uuid, name, description, barcode, price, make) values (21, 'Ranchero - Primerba, Paste', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 99088889506, 3.89, 'rutrum');
insert into items (uuid, name, description, barcode, price, make) values (22, 'Pumpkin - Seed', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 48287151923, 6.28, 'odio');
insert into items (uuid, name, description, barcode, price, make) values (23, 'Salami - Genova', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 77455303864, 13.1, 'semper');
insert into items (uuid, name, description, barcode, price, make) values (24, 'Extract - Almond', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.', 10979385662, 41.3, 'sit');
insert into items (uuid, name, description, barcode, price, make) values (25, 'Oil - Olive Bertolli', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 37070675591, 13.82, 'justo');
insert into items (uuid, name, description, barcode, price, make) values (26, 'Taro Root', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 37450463942, 14.16, 'ridiculus');
insert into items (uuid, name, description, barcode, price, make) values (27, 'Nutmeg - Ground', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 26885044629, 43.93, 'potenti');
insert into items (uuid, name, description, barcode, price, make) values (28, 'Chocolate - Sugar Free Semi Choc', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 40865648415, 23.26, 'at');
insert into items (uuid, name, description, barcode, price, make) values (29, 'Wine - Beaujolais Villages', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 14165179397, 29.89, 'nulla');
insert into items (uuid, name, description, barcode, price, make) values (30, 'Bread - Roll, Italian', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 10200116364, 41.55, 'libero');
insert into items (uuid, name, description, barcode, price, make) values (31, 'Spice - Pepper Portions', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 91414873316, 43.5, 'mattis');
insert into items (uuid, name, description, barcode, price, make) values (32, 'Cleaner - Lime Away', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 98414216594, 17.04, 'morbi');
insert into items (uuid, name, description, barcode, price, make) values (33, 'Tea - Apple Green Tea', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 44720729831, 43.55, 'ligula');
insert into items (uuid, name, description, barcode, price, make) values (34, 'Barley - Pearl', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.', 35039310762, 8.63, 'in');
insert into items (uuid, name, description, barcode, price, make) values (35, 'Beef - Ground Medium', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 77347005498, 32.69, 'nunc');
insert into items (uuid, name, description, barcode, price, make) values (36, 'Pepper - Orange', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 82957623652, 35.37, 'proin');
insert into items (uuid, name, description, barcode, price, make) values (37, 'Sauce - Roasted Red Pepper', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 66029751866, 29.77, 'eros');
insert into items (uuid, name, description, barcode, price, make) values (38, 'Sour Puss Sour Apple', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 41435210234, 38.81, 'sit');
insert into items (uuid, name, description, barcode, price, make) values (39, 'Magnotta Bel Paese Red', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.

Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 81966005978, 16.32, 'consequat');
insert into items (uuid, name, description, barcode, price, make) values (40, 'Towel Multifold', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 54747130572, 4.1, 'aenean');
insert into items (uuid, name, description, barcode, price, make) values (41, 'Flower - Commercial Bronze', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 63711417009, 8.36, 'laoreet');
insert into items (uuid, name, description, barcode, price, make) values (42, 'Longos - Penne With Pesto', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 42003869822, 42.03, 'varius');
insert into items (uuid, name, description, barcode, price, make) values (43, 'Pasta - Orecchiette', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 60748964323, 7.26, 'risus');
insert into items (uuid, name, description, barcode, price, make) values (44, 'Lemonade - Island Tea, 591 Ml', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 49437390355, 41.24, 'justo');
insert into items (uuid, name, description, barcode, price, make) values (45, 'Dehydrated Kelp Kombo', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 34652672481, 2.97, 'sit');
insert into items (uuid, name, description, barcode, price, make) values (46, 'Momiji Oroshi Chili Sauce', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 66718222514, 40.25, 'odio');
insert into items (uuid, name, description, barcode, price, make) values (47, 'Aspic - Amber', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 83649661830, 30.92, 'quam');
insert into items (uuid, name, description, barcode, price, make) values (48, 'Beer - Sleemans Honey Brown', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 36469873919, 45.81, 'tellus');
insert into items (uuid, name, description, barcode, price, make) values (49, 'Wine - Sogrape Mateus Rose', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 10622227178, 47.32, 'at');
insert into items (uuid, name, description, barcode, price, make) values (50, 'Rum - White, Gg White', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 84430672879, 24.79, 'quis');
insert into items (uuid, name, description, barcode, price, make) values (51, 'Rabbit - Saddles', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 40896891049, 46.55, 'porttitor');
insert into items (uuid, name, description, barcode, price, make) values (52, 'Boogies', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 86897640412, 12.62, 'vestibulum');
insert into items (uuid, name, description, barcode, price, make) values (53, 'Pail For Lid 1537', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 29233650294, 22.26, 'nisi');
insert into items (uuid, name, description, barcode, price, make) values (54, 'Fish - Soup Base, Bouillon', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', 94210548836, 29.24, 'orci');
insert into items (uuid, name, description, barcode, price, make) values (55, 'Kahlua', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 15442939889, 20.7, 'mauris');
insert into items (uuid, name, description, barcode, price, make) values (56, 'Tea - Black Currant', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.', 36771444119, 29.1, 'felis');
insert into items (uuid, name, description, barcode, price, make) values (57, 'Cake - Cheese Cake 9 Inch', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 78607796871, 2.1, 'vestibulum');
insert into items (uuid, name, description, barcode, price, make) values (58, 'Flour Dark Rye', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 74476296118, 36.14, 'morbi');
insert into items (uuid, name, description, barcode, price, make) values (59, 'Yogurt - Peach, 175 Gr', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 31833616541, 8.06, 'vitae');
insert into items (uuid, name, description, barcode, price, make) values (60, 'Spinach - Frozen', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 85651701921, 13.75, 'eu');
insert into items (uuid, name, description, barcode, price, make) values (61, 'Mustard - Dry, Powder', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 35341437235, 42.16, 'auctor');
insert into items (uuid, name, description, barcode, price, make) values (62, 'Muffin Mix - Chocolate Chip', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 98339160435, 11.07, 'ipsum');
insert into items (uuid, name, description, barcode, price, make) values (63, 'Rambutan', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 41857232379, 12.37, 'pellentesque');
insert into items (uuid, name, description, barcode, price, make) values (64, 'Veal - Heart', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 39798805799, 3.02, 'sed');
insert into items (uuid, name, description, barcode, price, make) values (65, 'Appetizer - Mango Chevre', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 22362077235, 5.71, 'sapien');
insert into items (uuid, name, description, barcode, price, make) values (66, 'Rice - Brown', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 27716346462, 20.6, 'nisi');
insert into items (uuid, name, description, barcode, price, make) values (67, 'Glass Clear 7 Oz Xl', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.

Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 19994509347, 21.96, 'a');
insert into items (uuid, name, description, barcode, price, make) values (68, 'Yokaline', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 13731451704, 41.21, 'cursus');
insert into items (uuid, name, description, barcode, price, make) values (69, 'Seaweed Green Sheets', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 96373318337, 3.93, 'morbi');
insert into items (uuid, name, description, barcode, price, make) values (70, 'Pizza Pizza Dough', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 16856010091, 15.23, 'elit');
insert into items (uuid, name, description, barcode, price, make) values (71, 'Bay Leaf Fresh', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 83215290161, 39.1, 'tristique');
insert into items (uuid, name, description, barcode, price, make) values (72, 'Clam - Cherrystone', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 30153273066, 36.16, 'augue');
insert into items (uuid, name, description, barcode, price, make) values (73, 'Sesame Seed Black', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 40239320102, 27.49, 'eu');
insert into items (uuid, name, description, barcode, price, make) values (74, 'Towel - Roll White', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 77192249807, 6.98, 'nibh');
insert into items (uuid, name, description, barcode, price, make) values (75, 'Pears - Fiorelle', 'Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 63033398970, 21.17, 'pellentesque');
insert into items (uuid, name, description, barcode, price, make) values (76, 'Swiss Chard', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 11172083629, 18.48, 'libero');
insert into items (uuid, name, description, barcode, price, make) values (77, 'Cognac - Courvaisier', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 36109315470, 39.04, 'volutpat');
insert into items (uuid, name, description, barcode, price, make) values (78, 'Grapefruit - Pink', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 66749134736, 8.65, 'sapien');
insert into items (uuid, name, description, barcode, price, make) values (79, 'Remy Red', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 84418907560, 12.43, 'pellentesque');
insert into items (uuid, name, description, barcode, price, make) values (80, 'Soy Protein', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 70688213334, 48.02, 'vel');
insert into items (uuid, name, description, barcode, price, make) values (81, 'Tea - Grapefruit Green Tea', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 31351293161, 17.06, 'congue');
insert into items (uuid, name, description, barcode, price, make) values (82, 'Steampan - Lid For Half Size', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 73208665737, 45.71, 'fusce');
insert into items (uuid, name, description, barcode, price, make) values (83, 'Cream - 18%', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 15116853050, 30.34, 'ac');
insert into items (uuid, name, description, barcode, price, make) values (84, 'Soup Bowl Clear 8oz92008', 'Fusce consequat. Nulla nisl. Nunc nisl.', 65592505125, 32.2, 'in');
insert into items (uuid, name, description, barcode, price, make) values (85, 'V8 Splash Strawberry Banana', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 81393523617, 33.94, 'amet');
insert into items (uuid, name, description, barcode, price, make) values (86, 'Muffin - Mix - Strawberry Rhubarb', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 47082496699, 4.58, 'turpis');
insert into items (uuid, name, description, barcode, price, make) values (87, 'Flower - Commercial Bronze', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 31081489564, 47.33, 'habitasse');
insert into items (uuid, name, description, barcode, price, make) values (88, 'Tart Shells - Barquettes, Savory', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 47212300113, 24.94, 'vestibulum');
insert into items (uuid, name, description, barcode, price, make) values (89, 'Longos - Grilled Chicken With', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 23286837297, 18.47, 'scelerisque');
insert into items (uuid, name, description, barcode, price, make) values (90, 'Rambutan', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 14739007601, 19.72, 'ligula');
insert into items (uuid, name, description, barcode, price, make) values (91, 'Wine - White, Riesling, Semi - Dry', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 59682288293, 10.26, 'nascetur');
insert into items (uuid, name, description, barcode, price, make) values (92, 'Whmis - Spray Bottle Trigger', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 35258742552, 19.94, 'at');
insert into items (uuid, name, description, barcode, price, make) values (93, 'Bread - Italian Corn Meal Poly', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 42843393872, 29.57, 'volutpat');
insert into items (uuid, name, description, barcode, price, make) values (94, 'Cheese - Montery Jack', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 66119601942, 32.37, 'rutrum');
insert into items (uuid, name, description, barcode, price, make) values (95, 'Bagel - 12 Grain Preslice', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 85097243799, 46.92, 'ante');
insert into items (uuid, name, description, barcode, price, make) values (96, 'Pasta - Fettuccine, Egg, Fresh', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 46317637117, 27.37, 'sapien');
insert into items (uuid, name, description, barcode, price, make) values (97, 'Daikon Radish', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 23461245305, 41.39, 'morbi');
insert into items (uuid, name, description, barcode, price, make) values (98, 'Lid - 10,12,16 Oz', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 87780077033, 1.14, 'est');
insert into items (uuid, name, description, barcode, price, make) values (99, 'Gelatine Leaves - Bulk', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 19619252416, 8.23, 'vestibulum');
insert into items (uuid, name, description, barcode, price, make) values (100, 'Bagel - Sesame Seed Presliced', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 42534417781, 5.27, 'in');
insert into items (uuid, name, description, barcode, price, make) values (101, 'Beer - Maudite', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 71420664055, 43.53, 'non');
insert into items (uuid, name, description, barcode, price, make) values (102, 'Mushroom - Porcini, Dry', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 85684845260, 29.4, 'convallis');
insert into items (uuid, name, description, barcode, price, make) values (103, 'Pork - Suckling Pig', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 52554286359, 37.99, 'cubilia');
insert into items (uuid, name, description, barcode, price, make) values (104, 'Table Cloth 62x120 White', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 37253593195, 23.13, 'vestibulum');
insert into items (uuid, name, description, barcode, price, make) values (105, 'Spice - Peppercorn Melange', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 15500774029, 27.08, 'luctus');
insert into items (uuid, name, description, barcode, price, make) values (106, 'Sloe Gin - Mcguinness', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 72674968573, 39.88, 'eget');
insert into items (uuid, name, description, barcode, price, make) values (107, 'Sword Pick Asst', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.

Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 27286607305, 38.47, 'nulla');
insert into items (uuid, name, description, barcode, price, make) values (108, 'Pepper - Orange', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 65373780015, 15.46, 'nulla');
insert into items (uuid, name, description, barcode, price, make) values (109, 'Wine - Semi Dry Riesling Vineland', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 97224157282, 28.6, 'rhoncus');
insert into items (uuid, name, description, barcode, price, make) values (110, 'Tea - Vanilla Chai', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 88036267528, 37.95, 'velit');
insert into items (uuid, name, description, barcode, price, make) values (111, 'Tea - Mint', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 95121939633, 5.46, 'amet');
insert into items (uuid, name, description, barcode, price, make) values (112, 'Yoplait Drink', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.', 49123166391, 33.5, 'lectus');
insert into items (uuid, name, description, barcode, price, make) values (113, 'Water - Spring Water, 355 Ml', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 78978655391, 23.44, 'morbi');
insert into items (uuid, name, description, barcode, price, make) values (114, 'Pork - Caul Fat', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 52905948708, 44.05, 'rhoncus');
insert into items (uuid, name, description, barcode, price, make) values (115, 'Spice - Chili Powder Mexican', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 60604521344, 16.33, 'libero');
insert into items (uuid, name, description, barcode, price, make) values (116, 'Pastry - Mini French Pastries', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 63704141024, 25.52, 'sed');
insert into items (uuid, name, description, barcode, price, make) values (117, 'Crab - Back Fin Meat, Canned', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 66178853220, 29.62, 'nulla');
insert into items (uuid, name, description, barcode, price, make) values (118, 'Sugar - Splenda Sweetener', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 90941670524, 41.42, 'dui');
insert into items (uuid, name, description, barcode, price, make) values (119, 'Pastry - Baked Scones - Mini', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 13708401967, 37.3, 'eros');
insert into items (uuid, name, description, barcode, price, make) values (120, 'Mangoes', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 62980515627, 14.95, 'congue');
insert into items (uuid, name, description, barcode, price, make) values (121, 'Cake - Night And Day Choclate', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 66735490070, 44.6, 'sapien');
insert into items (uuid, name, description, barcode, price, make) values (122, 'Sauce - Soy Low Sodium - 3.87l', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 67680197870, 12.13, 'diam');
insert into items (uuid, name, description, barcode, price, make) values (123, 'Muffin Mix - Raisin Bran', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 85377306604, 11.83, 'id');
insert into items (uuid, name, description, barcode, price, make) values (124, 'Container - Hngd Cll Blk 7x7x3', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 39209286575, 18.7, 'nulla');
insert into items (uuid, name, description, barcode, price, make) values (125, 'Teriyaki Sauce', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 78405850161, 11.67, 'sapien');
insert into items (uuid, name, description, barcode, price, make) values (126, 'Tomatoes - Yellow Hot House', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 28421742302, 43.32, 'gravida');
insert into items (uuid, name, description, barcode, price, make) values (127, 'Smoked Tongue', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 33874289872, 19.89, 'aliquet');
insert into items (uuid, name, description, barcode, price, make) values (128, 'Bread - Pumpernickle, Rounds', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 26771997586, 46.82, 'lorem');
insert into items (uuid, name, description, barcode, price, make) values (129, 'Star Anise, Whole', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 35117870354, 3.41, 'at');
insert into items (uuid, name, description, barcode, price, make) values (130, 'Cleaner - Lime Away', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 78467631000, 16.92, 'eget');
insert into items (uuid, name, description, barcode, price, make) values (131, 'Wine - Jafflin Bourgongone', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 11310682948, 25.67, 'ac');
insert into items (uuid, name, description, barcode, price, make) values (132, 'Crackers - Melba Toast', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 93861223908, 10.97, 'in');
insert into items (uuid, name, description, barcode, price, make) values (133, 'Tia Maria', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 67733925852, 36.33, 'nisl');
insert into items (uuid, name, description, barcode, price, make) values (134, 'V8 Splash Strawberry Kiwi', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 37904609928, 9.93, 'nisl');
insert into items (uuid, name, description, barcode, price, make) values (135, 'Cheese - Grana Padano', 'In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 23458950875, 36.6, 'sapien');
insert into items (uuid, name, description, barcode, price, make) values (136, 'Lumpfish Black', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 89577301659, 44.8, 'nulla');
insert into items (uuid, name, description, barcode, price, make) values (137, 'Beer - Molson Excel', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 91575174462, 42.07, 'accumsan');
insert into items (uuid, name, description, barcode, price, make) values (138, 'Cakes Assorted', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 11650696003, 18.45, 'sodales');
insert into items (uuid, name, description, barcode, price, make) values (139, 'Soup - Knorr, Veg / Beef', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 57215336162, 39.23, 'odio');
insert into items (uuid, name, description, barcode, price, make) values (140, 'Oats Large Flake', 'In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 17921654403, 16.88, 'duis');
insert into items (uuid, name, description, barcode, price, make) values (141, 'Yukon Jack', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 68792981665, 45.23, 'nunc');
insert into items (uuid, name, description, barcode, price, make) values (142, 'Salami - Genova', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 17346555474, 41.35, 'elit');
insert into items (uuid, name, description, barcode, price, make) values (143, 'Oregano - Dry, Rubbed', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 51800577988, 43.04, 'semper');
insert into items (uuid, name, description, barcode, price, make) values (144, 'Foil Wrap', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 89689027044, 41.58, 'nibh');
insert into items (uuid, name, description, barcode, price, make) values (145, 'Juice - Lime', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 77165773062, 49.99, 'sapien');
insert into items (uuid, name, description, barcode, price, make) values (146, 'Wine - Red, Marechal Foch', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 96780362622, 49.04, 'lobortis');
insert into items (uuid, name, description, barcode, price, make) values (147, 'Momiji Oroshi Chili Sauce', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 17993317302, 10.45, 'pede');
insert into items (uuid, name, description, barcode, price, make) values (148, 'Wine - Crozes Hermitage E.', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 32230169244, 29.83, 'viverra');
insert into items (uuid, name, description, barcode, price, make) values (149, 'Towel Dispenser', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 50859175740, 41.59, 'orci');
insert into items (uuid, name, description, barcode, price, make) values (150, 'Mackerel Whole Fresh', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 32680772620, 43.77, 'augue');
insert into items (uuid, name, description, barcode, price, make) values (151, 'Trueblue - Blueberry', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 79910029494, 27.33, 'pellentesque');
insert into items (uuid, name, description, barcode, price, make) values (152, 'Shallots', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 36301770266, 39.63, 'ultrices');
insert into items (uuid, name, description, barcode, price, make) values (153, 'Wine - Chianti Classico Riserva', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 45138734415, 29.56, 'duis');
insert into items (uuid, name, description, barcode, price, make) values (154, 'Wanton Wrap', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 58745500162, 30.25, 'lorem');
insert into items (uuid, name, description, barcode, price, make) values (155, 'Instant Coffee', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 15245865922, 35.62, 'habitasse');
insert into items (uuid, name, description, barcode, price, make) values (156, 'Lettuce - Red Leaf', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 75980091487, 49.67, 'vulputate');
insert into items (uuid, name, description, barcode, price, make) values (157, 'Cassis', 'Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 48515675843, 30.39, 'amet');
insert into items (uuid, name, description, barcode, price, make) values (158, 'Miso - Soy Bean Paste', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 39156941710, 27.1, 'nullam');
insert into items (uuid, name, description, barcode, price, make) values (159, 'Pork - Back, Long Cut, Boneless', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 50854343157, 45.91, 'in');
insert into items (uuid, name, description, barcode, price, make) values (160, 'Apple - Northern Spy', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 90083652118, 40.05, 'tempus');
insert into items (uuid, name, description, barcode, price, make) values (161, 'Egg - Salad Premix', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 34491003379, 9.6, 'sit');
insert into items (uuid, name, description, barcode, price, make) values (162, 'Salt And Pepper Mix - White', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 99744506025, 28.34, 'orci');
insert into items (uuid, name, description, barcode, price, make) values (163, 'Crackers - Soda / Saltins', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 82916586070, 16.58, 'volutpat');
insert into items (uuid, name, description, barcode, price, make) values (164, 'Cleaner - Lime Away', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 13434701910, 7.98, 'habitasse');
insert into items (uuid, name, description, barcode, price, make) values (165, 'Mushroom - Portebello', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 22193210869, 3.9, 'aenean');
insert into items (uuid, name, description, barcode, price, make) values (166, 'Amarula Cream', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 18315121409, 1.88, 'mattis');
insert into items (uuid, name, description, barcode, price, make) values (167, 'Pasta - Detalini, White, Fresh', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 90556460111, 42.85, 'dis');
insert into items (uuid, name, description, barcode, price, make) values (168, 'Peach - Halves', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 70473589080, 41.82, 'nullam');
insert into items (uuid, name, description, barcode, price, make) values (169, 'Beef - Top Butt Aaa', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 99886628043, 17.57, 'justo');
insert into items (uuid, name, description, barcode, price, make) values (170, 'Juice - Orange, 341 Ml', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 44065927826, 17.49, 'sed');
insert into items (uuid, name, description, barcode, price, make) values (171, 'Compound - Raspberry', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 99249788312, 41.04, 'luctus');
insert into items (uuid, name, description, barcode, price, make) values (172, 'Muffin Hinge Container 6', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 19870197888, 42.09, 'amet');
insert into items (uuid, name, description, barcode, price, make) values (173, 'Beans - French', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 80805380644, 29.01, 'purus');
insert into items (uuid, name, description, barcode, price, make) values (174, 'Rum - Mount Gay Eclipes', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 44879480189, 11.82, 'nec');
insert into items (uuid, name, description, barcode, price, make) values (175, 'Grand Marnier', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 44944135489, 9.15, 'velit');
insert into items (uuid, name, description, barcode, price, make) values (176, 'Milk - Chocolate 500ml', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 35885327716, 5.75, 'pede');
insert into items (uuid, name, description, barcode, price, make) values (177, 'Glove - Cutting', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 67481831701, 10.0, 'dapibus');
insert into items (uuid, name, description, barcode, price, make) values (178, 'Cheese - Parmigiano Reggiano', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 62112565550, 43.43, 'magna');
insert into items (uuid, name, description, barcode, price, make) values (179, 'Rice - Wild', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 98387809835, 18.31, 'tristique');
insert into items (uuid, name, description, barcode, price, make) values (180, 'Wine - Magnotta - Red, Baco', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 90047665083, 34.01, 'condimentum');
insert into items (uuid, name, description, barcode, price, make) values (181, 'Nut - Peanut, Roasted', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 16792510543, 33.59, 'hendrerit');
insert into items (uuid, name, description, barcode, price, make) values (182, 'Pear - Asian', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 39848959211, 48.68, 'amet');
insert into items (uuid, name, description, barcode, price, make) values (183, 'Salami - Genova', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.', 76601509447, 27.24, 'et');
insert into items (uuid, name, description, barcode, price, make) values (184, 'Puff Pastry - Sheets', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 22130951652, 29.11, 'condimentum');
insert into items (uuid, name, description, barcode, price, make) values (185, 'Vinegar - White Wine', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 79726598354, 32.21, 'morbi');
insert into items (uuid, name, description, barcode, price, make) values (186, 'Mustard - Pommery', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 27793407176, 44.85, 'purus');
insert into items (uuid, name, description, barcode, price, make) values (187, 'Wine - Red, Mouton Cadet', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 18561739119, 3.46, 'aliquam');
insert into items (uuid, name, description, barcode, price, make) values (188, 'Oil - Shortening,liqud, Fry', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 24047514053, 27.07, 'faucibus');
insert into items (uuid, name, description, barcode, price, make) values (189, 'Pork - Chop, Frenched', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 25632225225, 20.64, 'integer');
insert into items (uuid, name, description, barcode, price, make) values (190, 'Campari', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 88687968520, 15.64, 'posuere');
insert into items (uuid, name, description, barcode, price, make) values (191, 'Nantucket - Pomegranate Pear', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.', 35060112330, 47.31, 'morbi');
insert into items (uuid, name, description, barcode, price, make) values (192, 'Flour - Strong', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 66789552659, 13.35, 'fringilla');
insert into items (uuid, name, description, barcode, price, make) values (193, 'Beans - French', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', 54812428739, 41.82, 'interdum');
insert into items (uuid, name, description, barcode, price, make) values (194, 'Water - Spring 1.5lit', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 28956990091, 19.95, 'at');
insert into items (uuid, name, description, barcode, price, make) values (195, 'Sparkling Wine - Rose, Freixenet', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 32192208515, 1.13, 'vitae');
insert into items (uuid, name, description, barcode, price, make) values (196, 'Pork - Bacon, Double Smoked', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 31633999737, 10.74, 'congue');
insert into items (uuid, name, description, barcode, price, make) values (197, 'Corn Shoots', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 54161161572, 21.07, 'aliquet');
insert into items (uuid, name, description, barcode, price, make) values (198, 'Pastry - Plain Baked Croissant', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 82880148691, 32.74, 'diam');
insert into items (uuid, name, description, barcode, price, make) values (199, 'English Muffin', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 79956999648, 37.09, 'suscipit');
insert into items (uuid, name, description, barcode, price, make) values (200, 'French Pastry - Mini Chocolate', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 68800168256, 24.66, 'luctus');
insert into items (uuid, name, description, barcode, price, make) values (201, 'Foil - Round Foil', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 26250141584, 34.68, 'maecenas');
insert into items (uuid, name, description, barcode, price, make) values (202, 'Nescafe - Frothy French Vanilla', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 61816929499, 44.05, 'eros');
insert into items (uuid, name, description, barcode, price, make) values (203, 'Mousse - Banana Chocolate', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 33914898024, 8.29, 'condimentum');
insert into items (uuid, name, description, barcode, price, make) values (204, 'Wine - Fontanafredda Barolo', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 16330481673, 38.55, 'quam');
insert into items (uuid, name, description, barcode, price, make) values (205, 'Lettuce - Green Leaf', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 62257052338, 41.42, 'rhoncus');
insert into items (uuid, name, description, barcode, price, make) values (206, 'Wine - Barolo Fontanafredda', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 81125623089, 14.42, 'amet');
insert into items (uuid, name, description, barcode, price, make) values (207, 'Pastry - Key Limepoppy Seed Tea', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 36569399729, 14.02, 'nulla');
insert into items (uuid, name, description, barcode, price, make) values (208, 'Wine - Red, Cooking', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 88177806130, 31.13, 'elementum');
insert into items (uuid, name, description, barcode, price, make) values (209, 'Wine - Cotes Du Rhone', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 27985270977, 36.64, 'viverra');
insert into items (uuid, name, description, barcode, price, make) values (210, 'Toothpick Frilled', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 71246869150, 5.71, 'vel');
insert into items (uuid, name, description, barcode, price, make) values (211, 'Tart Shells - Sweet, 3', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 17317471201, 35.74, 'ultrices');
insert into items (uuid, name, description, barcode, price, make) values (212, 'Rice - Basmati', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 63141089854, 9.42, 'rhoncus');
insert into items (uuid, name, description, barcode, price, make) values (213, 'Sugar - Palm', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 84893338644, 45.77, 'mauris');
insert into items (uuid, name, description, barcode, price, make) values (214, 'Versatainer Nc - 9388', 'Fusce consequat. Nulla nisl. Nunc nisl.', 34031830698, 2.59, 'ante');
insert into items (uuid, name, description, barcode, price, make) values (215, 'Lettuce - Romaine', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', 26605407453, 12.27, 'imperdiet');
insert into items (uuid, name, description, barcode, price, make) values (216, 'Pastry - Chocolate Chip Muffin', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 20724774302, 29.44, 'justo');
insert into items (uuid, name, description, barcode, price, make) values (217, 'Syrup - Chocolate', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 44212316279, 13.28, 'suspendisse');
insert into items (uuid, name, description, barcode, price, make) values (218, 'Wine - Bouchard La Vignee Pinot', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.', 87659610648, 23.4, 'vitae');
insert into items (uuid, name, description, barcode, price, make) values (219, 'Bread - Sour Sticks With Onion', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 71903177660, 28.3, 'est');
insert into items (uuid, name, description, barcode, price, make) values (220, 'Sprouts - Peppercress', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 39438333937, 32.07, 'eget');
insert into items (uuid, name, description, barcode, price, make) values (221, 'Lemonade - Island Tea, 591 Ml', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 75300886163, 12.91, 'in');
insert into items (uuid, name, description, barcode, price, make) values (222, 'Arctic Char - Fresh, Whole', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 30851165754, 40.73, 'dui');
insert into items (uuid, name, description, barcode, price, make) values (223, 'Pur Value', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 99993247366, 15.61, 'suscipit');
insert into items (uuid, name, description, barcode, price, make) values (224, 'Compound - Mocha', 'Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 15360354229, 42.8, 'tempus');
insert into items (uuid, name, description, barcode, price, make) values (225, 'Tart Shells - Savory, 2', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 15236753365, 19.66, 'duis');
insert into items (uuid, name, description, barcode, price, make) values (226, 'Soup - Campbells, Butternut', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 32059818569, 15.67, 'eros');
insert into items (uuid, name, description, barcode, price, make) values (227, 'Vermouth - Sweet, Cinzano', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 19445504443, 23.41, 'venenatis');
insert into items (uuid, name, description, barcode, price, make) values (228, 'Wine - German Riesling', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 75004004509, 18.14, 'porttitor');
insert into items (uuid, name, description, barcode, price, make) values (229, 'Beer - Labatt Blue', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 59450214482, 22.87, 'et');
insert into items (uuid, name, description, barcode, price, make) values (230, 'Sauce Tomato Pouch', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 87154364631, 1.46, 'volutpat');
insert into items (uuid, name, description, barcode, price, make) values (231, 'Pork - Ham, Virginia', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 64055269647, 42.4, 'aliquet');
insert into items (uuid, name, description, barcode, price, make) values (232, 'Tea - Herbal Orange Spice', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 42964976215, 28.58, 'ligula');
insert into items (uuid, name, description, barcode, price, make) values (233, 'Chicken - Leg / Back Attach', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 23325388517, 8.1, 'sed');
insert into items (uuid, name, description, barcode, price, make) values (234, 'Extract - Raspberry', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 28383005473, 36.72, 'justo');
insert into items (uuid, name, description, barcode, price, make) values (235, 'Cheese - Perron Cheddar', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 15122764945, 28.48, 'tincidunt');
insert into items (uuid, name, description, barcode, price, make) values (236, 'Pepper - Green, Chili', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 11078193717, 45.62, 'quis');
insert into items (uuid, name, description, barcode, price, make) values (237, 'Coconut - Shredded, Unsweet', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 29413022734, 28.8, 'felis');
insert into items (uuid, name, description, barcode, price, make) values (238, 'Lid - 16 Oz And 32 Oz', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 46096514721, 39.83, 'vulputate');
insert into items (uuid, name, description, barcode, price, make) values (239, 'Bread Sour Rolls', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 56853984872, 13.77, 'magna');
insert into items (uuid, name, description, barcode, price, make) values (240, 'Bread - White, Unsliced', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 70443458183, 35.91, 'leo');
insert into items (uuid, name, description, barcode, price, make) values (241, 'Island Oasis - Wildberry', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 65285703896, 23.92, 'urna');
insert into items (uuid, name, description, barcode, price, make) values (242, 'Onion - Dried', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 93501150075, 42.72, 'metus');
insert into items (uuid, name, description, barcode, price, make) values (243, 'Buffalo - Short Rib Fresh', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 48137770140, 16.37, 'massa');
insert into items (uuid, name, description, barcode, price, make) values (244, 'Placemat - Scallop, White', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 58888814660, 43.51, 'sapien');
insert into items (uuid, name, description, barcode, price, make) values (245, 'Kaffir Lime Leaves', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 43596877537, 42.66, 'elit');
insert into items (uuid, name, description, barcode, price, make) values (246, 'Beer - Sleemans Honey Brown', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 12814241851, 39.86, 'quis');
insert into items (uuid, name, description, barcode, price, make) values (247, 'Beets - Candy Cane, Organic', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.

Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 27448138469, 6.62, 'duis');
insert into items (uuid, name, description, barcode, price, make) values (248, 'Squid U5 - Thailand', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 71386520190, 27.52, 'purus');
insert into items (uuid, name, description, barcode, price, make) values (249, 'Pastry - Choclate Baked', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 81300439496, 44.81, 'in');
insert into items (uuid, name, description, barcode, price, make) values (250, 'Spinach - Spinach Leaf', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 77671670676, 15.47, 'sit');
insert into items (uuid, name, description, barcode, price, make) values (251, 'Trueblue - Blueberry 12x473ml', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 32201608222, 27.37, 'donec');
insert into items (uuid, name, description, barcode, price, make) values (252, 'Basil - Dry, Rubbed', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 34300149780, 4.7, 'aliquam');
insert into items (uuid, name, description, barcode, price, make) values (253, 'Pepper - Green, Chili', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 44558281296, 14.89, 'nisi');
insert into items (uuid, name, description, barcode, price, make) values (254, 'Wine - Red Oakridge Merlot', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 80439101497, 3.83, 'eget');
insert into items (uuid, name, description, barcode, price, make) values (255, 'Vol Au Vents', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 36236195265, 44.31, 'maecenas');
insert into items (uuid, name, description, barcode, price, make) values (256, 'Bread - Rolls, Corn', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 86108996215, 41.14, 'nullam');
insert into items (uuid, name, description, barcode, price, make) values (257, 'Jicama', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 14414105020, 24.43, 'tincidunt');
insert into items (uuid, name, description, barcode, price, make) values (258, 'Cherries - Bing, Canned', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 22947740643, 13.02, 'pede');
insert into items (uuid, name, description, barcode, price, make) values (259, 'Wine - Crozes Hermitage E.', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 81159393715, 27.96, 'interdum');
insert into items (uuid, name, description, barcode, price, make) values (260, 'Cabbage - Green', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.

Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 74259524096, 34.69, 'neque');
insert into items (uuid, name, description, barcode, price, make) values (261, 'Salmon - Atlantic, No Skin', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 25770924325, 24.95, 'consequat');
insert into items (uuid, name, description, barcode, price, make) values (262, 'Appetizer - Lobster Phyllo Roll', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 43631507918, 6.03, 'sapien');
insert into items (uuid, name, description, barcode, price, make) values (263, 'Bagel - 12 Grain Preslice', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 80858686994, 1.3, 'accumsan');
insert into items (uuid, name, description, barcode, price, make) values (264, 'Pastry - Chocolate Chip Muffin', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 52297894759, 28.56, 'magna');
insert into items (uuid, name, description, barcode, price, make) values (265, 'Pork - Hock And Feet Attached', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 72193216099, 31.79, 'nec');
insert into items (uuid, name, description, barcode, price, make) values (266, 'Beer - Creemore', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 96488503782, 13.28, 'in');
insert into items (uuid, name, description, barcode, price, make) values (267, 'Bandage - Fexible 1x3', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 90974360051, 8.93, 'sed');
insert into items (uuid, name, description, barcode, price, make) values (268, 'Truffle Shells - Semi - Sweet', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 82929504327, 31.3, 'dui');
insert into items (uuid, name, description, barcode, price, make) values (269, 'Beer - Moosehead', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 33062736726, 21.97, 'nulla');
insert into items (uuid, name, description, barcode, price, make) values (270, 'Sprouts Dikon', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 14883836302, 6.67, 'venenatis');
insert into items (uuid, name, description, barcode, price, make) values (271, 'Apple - Northern Spy', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 32192209412, 45.32, 'non');
insert into items (uuid, name, description, barcode, price, make) values (272, 'Oysters - Smoked', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 75371573448, 32.84, 'eu');
insert into items (uuid, name, description, barcode, price, make) values (273, 'Bread - Roll, Italian', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 97272758616, 16.46, 'ac');
insert into items (uuid, name, description, barcode, price, make) values (274, 'Muffin - Mix - Creme Brule 15l', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 72494830326, 1.81, 'in');
insert into items (uuid, name, description, barcode, price, make) values (275, 'Pepper - Red Bell', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 26723222870, 39.04, 'semper');
insert into items (uuid, name, description, barcode, price, make) values (276, 'Kolrabi', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 22977898065, 39.55, 'auctor');
insert into items (uuid, name, description, barcode, price, make) values (277, 'Cream - 35%', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 58028502699, 44.89, 'metus');
insert into items (uuid, name, description, barcode, price, make) values (278, 'Muffin Orange Individual', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 65732768484, 47.16, 'lacus');
insert into items (uuid, name, description, barcode, price, make) values (279, 'Mustard - Individual Pkg', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 41299635049, 36.14, 'sed');
insert into items (uuid, name, description, barcode, price, make) values (280, 'Spice - Pepper Portions', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 42461050891, 34.85, 'in');
insert into items (uuid, name, description, barcode, price, make) values (281, 'Bread - White, Sliced', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 47390837672, 49.16, 'aenean');
insert into items (uuid, name, description, barcode, price, make) values (282, 'Paper Cocktail Umberlla 80 - 180', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 30499834397, 21.69, 'augue');
insert into items (uuid, name, description, barcode, price, make) values (283, 'Tart Shells - Savory, 3', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 12625841901, 38.75, 'elit');
insert into items (uuid, name, description, barcode, price, make) values (284, 'Monkfish Fresh - Skin Off', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 35537798861, 6.84, 'dictumst');
insert into items (uuid, name, description, barcode, price, make) values (285, 'Cod - Fillets', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 45229331589, 32.86, 'viverra');
insert into items (uuid, name, description, barcode, price, make) values (286, 'Mustard - Individual Pkg', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 90925493052, 32.32, 'feugiat');
insert into items (uuid, name, description, barcode, price, make) values (287, 'Juice - Cranberry 284ml', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 77641459644, 16.89, 'pretium');
insert into items (uuid, name, description, barcode, price, make) values (288, 'Oil - Safflower', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 27259274307, 43.37, 'volutpat');
insert into items (uuid, name, description, barcode, price, make) values (289, 'Muskox - French Rack', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 43304697978, 41.11, 'amet');
insert into items (uuid, name, description, barcode, price, make) values (290, 'Dill Weed - Dry', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 94911022995, 23.11, 'amet');
insert into items (uuid, name, description, barcode, price, make) values (291, 'Petite Baguette', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 55123980323, 22.78, 'in');
insert into items (uuid, name, description, barcode, price, make) values (292, 'Beer - Moosehead', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 52345387665, 20.67, 'diam');
insert into items (uuid, name, description, barcode, price, make) values (293, 'Pickerel - Fillets', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 66481630116, 41.58, 'in');
insert into items (uuid, name, description, barcode, price, make) values (294, 'Alize Red Passion', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 70616787701, 45.46, 'vestibulum');
insert into items (uuid, name, description, barcode, price, make) values (295, 'Ecolab Silver Fusion', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 57939313994, 29.53, 'odio');
insert into items (uuid, name, description, barcode, price, make) values (296, 'Tia Maria', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 38499151167, 37.92, 'condimentum');
insert into items (uuid, name, description, barcode, price, make) values (297, 'Bread - Sour Sticks With Onion', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 36244506699, 49.59, 'luctus');
insert into items (uuid, name, description, barcode, price, make) values (298, 'Seedlings - Clamshell', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 42491677275, 11.41, 'amet');
insert into items (uuid, name, description, barcode, price, make) values (299, 'Wine - Mondavi Coastal Private', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 88072052742, 39.3, 'curabitur');
insert into items (uuid, name, description, barcode, price, make) values (300, 'Coffee - Dark Roast', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 38028464149, 10.2, 'nulla');
insert into items (uuid, name, description, barcode, price, make) values (301, 'Longos - Chicken Curried', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 55670543638, 18.81, 'quis');
insert into items (uuid, name, description, barcode, price, make) values (302, 'Appetizer - Asian Shrimp Roll', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 85883650968, 44.03, 'proin');
insert into items (uuid, name, description, barcode, price, make) values (303, 'Doilies - 5, Paper', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 47587774346, 28.8, 'lobortis');
insert into items (uuid, name, description, barcode, price, make) values (304, 'Pork - Tenderloin, Fresh', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 34013463931, 41.39, 'pede');
insert into items (uuid, name, description, barcode, price, make) values (305, 'Dikon', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 47163905906, 48.87, 'lectus');
insert into items (uuid, name, description, barcode, price, make) values (306, 'Beef - Chuck, Boneless', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 92109657049, 39.63, 'mauris');
insert into items (uuid, name, description, barcode, price, make) values (307, 'Soup Campbells - Italian Wedding', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 62608509248, 46.44, 'mattis');
insert into items (uuid, name, description, barcode, price, make) values (308, 'Garam Marsala', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 25791409681, 39.82, 'justo');
insert into items (uuid, name, description, barcode, price, make) values (309, 'Vinegar - Tarragon', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 78408725049, 4.28, 'aliquet');
insert into items (uuid, name, description, barcode, price, make) values (310, 'Beef - Short Loin', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 85331267902, 11.64, 'congue');
insert into items (uuid, name, description, barcode, price, make) values (311, 'Napkin White - Starched', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 63103274430, 2.46, 'maecenas');
insert into items (uuid, name, description, barcode, price, make) values (312, 'Tea - Decaf 1 Cup', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 36125831650, 47.58, 'convallis');
insert into items (uuid, name, description, barcode, price, make) values (313, 'Halibut - Fletches', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.', 13301378117, 3.82, 'ante');
insert into items (uuid, name, description, barcode, price, make) values (314, 'Gooseberry', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 26710290056, 9.61, 'vestibulum');
insert into items (uuid, name, description, barcode, price, make) values (315, 'Sausage - Meat', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 88685280872, 22.4, 'suspendisse');
insert into items (uuid, name, description, barcode, price, make) values (316, 'Cheese - Victor Et Berthold', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 50519661877, 24.04, 'quis');
insert into items (uuid, name, description, barcode, price, make) values (317, 'Pike - Frozen Fillet', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 78440417865, 40.2, 'elementum');
insert into items (uuid, name, description, barcode, price, make) values (318, 'Chicken - Leg, Boneless', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 19012063861, 33.66, 'tristique');
insert into items (uuid, name, description, barcode, price, make) values (319, 'Soup - Knorr, Veg / Beef', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 25040742200, 48.98, 'id');
insert into items (uuid, name, description, barcode, price, make) values (320, 'Beef - Cooked, Corned', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 64392248201, 39.35, 'donec');
insert into items (uuid, name, description, barcode, price, make) values (321, 'Tea - English Breakfast', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 38157294330, 2.69, 'blandit');
insert into items (uuid, name, description, barcode, price, make) values (322, 'Liquid Aminios Acid - Braggs', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 36278252717, 8.3, 'augue');
insert into items (uuid, name, description, barcode, price, make) values (323, 'Muffin - Mix - Creme Brule 15l', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 56280910235, 28.59, 'felis');
insert into items (uuid, name, description, barcode, price, make) values (324, 'Bacardi Limon', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 17558363599, 35.08, 'ac');
insert into items (uuid, name, description, barcode, price, make) values (325, 'Cookies - Englishbay Oatmeal', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 86510421553, 35.73, 'lorem');
insert into items (uuid, name, description, barcode, price, make) values (326, 'Cookie - Oatmeal', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 58290106725, 8.73, 'metus');
insert into items (uuid, name, description, barcode, price, make) values (327, 'Cumin - Ground', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 42008013121, 30.68, 'diam');
insert into items (uuid, name, description, barcode, price, make) values (328, 'Flower - Leather Leaf Fern', 'Fusce consequat. Nulla nisl. Nunc nisl.', 72878142358, 42.93, 'pellentesque');
insert into items (uuid, name, description, barcode, price, make) values (329, 'Mushroom - Trumpet, Dry', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 19693121078, 6.64, 'duis');
insert into items (uuid, name, description, barcode, price, make) values (330, 'Potatoes - Yukon Gold, 80 Ct', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', 52131976051, 14.48, 'vulputate');
insert into items (uuid, name, description, barcode, price, make) values (331, 'Ecolab - Ster Bac', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 84610316711, 12.08, 'pede');
insert into items (uuid, name, description, barcode, price, make) values (332, 'Cheese - Parmigiano Reggiano', 'Fusce consequat. Nulla nisl. Nunc nisl.', 65714316177, 2.5, 'consequat');
insert into items (uuid, name, description, barcode, price, make) values (333, 'Wine - Merlot Vina Carmen', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 29401325681, 38.24, 'in');
insert into items (uuid, name, description, barcode, price, make) values (334, 'Broom And Brush Rack Black', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 73440793654, 45.3, 'scelerisque');
insert into items (uuid, name, description, barcode, price, make) values (335, 'Marjoram - Dried, Rubbed', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 84904201444, 36.89, 'ac');
insert into items (uuid, name, description, barcode, price, make) values (336, 'Broom - Corn', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 76519403219, 14.4, 'augue');
insert into items (uuid, name, description, barcode, price, make) values (337, 'Salmon - Atlantic, Fresh, Whole', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 55866760962, 15.83, 'pede');
insert into items (uuid, name, description, barcode, price, make) values (338, 'Mix - Cocktail Strawberry Daiquiri', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.

Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 52052546471, 9.2, 'quam');
insert into items (uuid, name, description, barcode, price, make) values (339, 'Milk - 1%', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 20921665612, 43.85, 'massa');
insert into items (uuid, name, description, barcode, price, make) values (340, 'Split Peas - Yellow, Dry', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 44211123562, 39.17, 'mattis');
insert into items (uuid, name, description, barcode, price, make) values (341, 'Bagel - 12 Grain Preslice', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 33103869890, 20.58, 'volutpat');
insert into items (uuid, name, description, barcode, price, make) values (342, 'Fuji Apples', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 18152400479, 29.34, 'in');
insert into items (uuid, name, description, barcode, price, make) values (343, 'Arctic Char - Fresh, Whole', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 57158070261, 29.35, 'elit');
insert into items (uuid, name, description, barcode, price, make) values (344, 'Pepper - Green', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 60161161426, 18.09, 'quis');
insert into items (uuid, name, description, barcode, price, make) values (345, 'Pastry - Trippleberry Muffin - Mini', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 44775335527, 36.81, 'tincidunt');
insert into items (uuid, name, description, barcode, price, make) values (346, 'Crab - Dungeness, Whole', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 91757299917, 35.4, 'quisque');
insert into items (uuid, name, description, barcode, price, make) values (347, 'Shrimp - Black Tiger 16/20', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 35646596451, 27.84, 'hendrerit');
insert into items (uuid, name, description, barcode, price, make) values (348, 'Garlic - Elephant', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', 91885554980, 38.15, 'aliquet');
insert into items (uuid, name, description, barcode, price, make) values (349, 'Potatoes - Purple, Organic', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 77707510004, 11.17, 'justo');
insert into items (uuid, name, description, barcode, price, make) values (350, 'Lettuce - Baby Salad Greens', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 19795354126, 41.6, 'dolor');
insert into items (uuid, name, description, barcode, price, make) values (351, 'Squeeze Bottle', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 24363892322, 2.03, 'elit');
insert into items (uuid, name, description, barcode, price, make) values (352, 'Cheese - Victor Et Berthold', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.

Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 60545864125, 22.7, 'ut');
insert into items (uuid, name, description, barcode, price, make) values (353, 'Pasta - Cheese / Spinach Bauletti', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 87842406418, 28.1, 'augue');
insert into items (uuid, name, description, barcode, price, make) values (354, 'Mudslide', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 33503350821, 4.78, 'auctor');
insert into items (uuid, name, description, barcode, price, make) values (355, 'Bread - Multigrain, Loaf', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 35473859942, 29.32, 'dui');
insert into items (uuid, name, description, barcode, price, make) values (356, 'Beer - True North Lager', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 66444227233, 45.99, 'nonummy');
insert into items (uuid, name, description, barcode, price, make) values (357, 'Roe - Lump Fish, Black', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 84265405400, 29.85, 'nibh');
insert into items (uuid, name, description, barcode, price, make) values (358, 'Chinese Lemon Pork', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 20539698525, 35.61, 'dui');
insert into items (uuid, name, description, barcode, price, make) values (359, 'Cookie Dough - Peanut Butter', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 35749552407, 25.74, 'maecenas');
insert into items (uuid, name, description, barcode, price, make) values (360, 'Roe - Flying Fish', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.', 44952036296, 42.31, 'odio');
insert into items (uuid, name, description, barcode, price, make) values (361, 'Beans - Butter Lrg Lima', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 10791637874, 38.06, 'pellentesque');
insert into items (uuid, name, description, barcode, price, make) values (362, 'Compound - Orange', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 45062563000, 33.13, 'pellentesque');
insert into items (uuid, name, description, barcode, price, make) values (363, 'Wooden Mop Handle', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', 15891984623, 40.41, 'nisi');
insert into items (uuid, name, description, barcode, price, make) values (364, 'Oil - Peanut', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 76518756280, 21.0, 'magnis');
insert into items (uuid, name, description, barcode, price, make) values (365, 'Sauce - Hollandaise', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 35097816859, 13.59, 'nunc');
insert into items (uuid, name, description, barcode, price, make) values (366, 'Eggs - Extra Large', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 47380563481, 42.02, 'non');
insert into items (uuid, name, description, barcode, price, make) values (367, 'Flour - Corn, Fine', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 91337663797, 3.43, 'dapibus');
insert into items (uuid, name, description, barcode, price, make) values (368, 'Sugar - Splenda Sweetener', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 68640791563, 31.52, 'sit');
insert into items (uuid, name, description, barcode, price, make) values (369, 'Scallop - St. Jaques', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 46325033564, 12.19, 'luctus');
insert into items (uuid, name, description, barcode, price, make) values (370, 'Emulsifier', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 22411668797, 28.94, 'in');
insert into items (uuid, name, description, barcode, price, make) values (371, 'Wine - Red, Pelee Island Merlot', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 50587274914, 21.27, 'justo');
insert into items (uuid, name, description, barcode, price, make) values (372, 'Cake - Box Window 10x10x2.5', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 23631188460, 25.04, 'est');
insert into items (uuid, name, description, barcode, price, make) values (373, 'Glycerine', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 30588126304, 2.91, 'proin');
insert into items (uuid, name, description, barcode, price, make) values (374, 'Sauerkraut', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 60519588443, 39.73, 'viverra');
insert into items (uuid, name, description, barcode, price, make) values (375, 'Irish Cream - Butterscotch', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 54657335228, 25.41, 'mi');
insert into items (uuid, name, description, barcode, price, make) values (376, 'Venison - Ground', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 60075639784, 18.55, 'lectus');
insert into items (uuid, name, description, barcode, price, make) values (377, 'Tomato - Plum With Basil', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 36662202494, 24.48, 'a');
insert into items (uuid, name, description, barcode, price, make) values (378, 'Capers - Ox Eye Daisy', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 67376198623, 1.38, 'turpis');
insert into items (uuid, name, description, barcode, price, make) values (379, 'Sage - Fresh', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 94105384078, 25.26, 'viverra');
insert into items (uuid, name, description, barcode, price, make) values (380, 'Eggwhite Frozen', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 42569587745, 41.5, 'hac');
insert into items (uuid, name, description, barcode, price, make) values (381, 'Yeast Dry - Fermipan', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 22697314830, 15.09, 'sollicitudin');
insert into items (uuid, name, description, barcode, price, make) values (382, 'Wine - Zinfandel Rosenblum', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 52197497820, 1.61, 'rutrum');
insert into items (uuid, name, description, barcode, price, make) values (383, 'Soup - Campbells, Cream Of', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 96161300906, 10.35, 'etiam');
insert into items (uuid, name, description, barcode, price, make) values (384, 'Pasta - Fettuccine, Dry', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 11011411134, 47.71, 'ridiculus');
insert into items (uuid, name, description, barcode, price, make) values (385, 'Lobster - Baby, Boiled', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 76468543409, 46.63, 'cubilia');
insert into items (uuid, name, description, barcode, price, make) values (386, 'Wine - White, Gewurtzraminer', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 29980984972, 15.01, 'quam');
insert into items (uuid, name, description, barcode, price, make) values (387, 'Lambcasing', 'Fusce consequat. Nulla nisl. Nunc nisl.', 18644411998, 1.05, 'eget');
insert into items (uuid, name, description, barcode, price, make) values (388, 'Wine - Black Tower Qr', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 69839683302, 30.84, 'mauris');
insert into items (uuid, name, description, barcode, price, make) values (389, 'Garlic', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 54721182627, 1.05, 'tristique');
insert into items (uuid, name, description, barcode, price, make) values (390, 'Wine - Casillero Deldiablo', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 33676004707, 37.1, 'ridiculus');
insert into items (uuid, name, description, barcode, price, make) values (391, 'Gatorade - Xfactor Berry', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 69408305367, 9.0, 'dolor');
insert into items (uuid, name, description, barcode, price, make) values (392, 'Pheasants - Whole', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 95205324537, 13.71, 'volutpat');
insert into items (uuid, name, description, barcode, price, make) values (393, 'Sesame Seed', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 19878970183, 11.68, 'consectetuer');
insert into items (uuid, name, description, barcode, price, make) values (394, 'Pork - Side Ribs', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 71877165580, 44.92, 'ut');
insert into items (uuid, name, description, barcode, price, make) values (395, 'Curry Powder Madras', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.

Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 74568603508, 26.41, 'non');
insert into items (uuid, name, description, barcode, price, make) values (396, 'Celery', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 37818789236, 17.41, 'pellentesque');
insert into items (uuid, name, description, barcode, price, make) values (397, 'Mushroom - Trumpet, Dry', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 98538206131, 7.61, 'nulla');
insert into items (uuid, name, description, barcode, price, make) values (398, 'Shrimp - Black Tiger 8 - 12', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 89451922508, 33.09, 'nulla');
insert into items (uuid, name, description, barcode, price, make) values (399, 'Whmis - Spray Bottle Trigger', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 25074592363, 41.54, 'molestie');
insert into items (uuid, name, description, barcode, price, make) values (400, 'Steel Wool S.o.s', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 63916146658, 23.95, 'dui');
insert into items (uuid, name, description, barcode, price, make) values (401, 'Plate - Foam, Bread And Butter', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 20987449064, 41.58, 'urna');
insert into items (uuid, name, description, barcode, price, make) values (402, 'Beef - Striploin', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 30523152632, 33.99, 'sapien');
insert into items (uuid, name, description, barcode, price, make) values (403, 'Steam Pan - Half Size Deep', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 41715334557, 35.41, 'dis');
insert into items (uuid, name, description, barcode, price, make) values (404, 'Soup Campbells Beef With Veg', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 33227043977, 44.26, 'nulla');
insert into items (uuid, name, description, barcode, price, make) values (405, 'Soup - Clam Chowder, Dry Mix', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 88215890425, 21.61, 'mi');
insert into items (uuid, name, description, barcode, price, make) values (406, 'Eggwhite Frozen', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 93664637878, 5.7, 'accumsan');
insert into items (uuid, name, description, barcode, price, make) values (407, 'Gingerale - Diet - Schweppes', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 96800852355, 33.15, 'nam');
insert into items (uuid, name, description, barcode, price, make) values (408, 'Beef - Bresaola', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 49351966654, 43.0, 'nulla');
insert into items (uuid, name, description, barcode, price, make) values (409, 'Graham Cracker Mix', 'In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 57861680665, 45.95, 'est');
insert into items (uuid, name, description, barcode, price, make) values (410, 'Wine - Piper Heidsieck Brut', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 94658737206, 6.11, 'convallis');
insert into items (uuid, name, description, barcode, price, make) values (411, 'Pork - Loin, Center Cut', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 85286273756, 39.62, 'orci');
insert into items (uuid, name, description, barcode, price, make) values (412, 'Venison - Racks Frenched', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 64468849180, 38.19, 'in');
insert into items (uuid, name, description, barcode, price, make) values (413, 'Yogurt - Peach, 175 Gr', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 23349084927, 22.33, 'morbi');
insert into items (uuid, name, description, barcode, price, make) values (414, 'Soup - Base Broth Beef', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 49839132999, 43.05, 'neque');
insert into items (uuid, name, description, barcode, price, make) values (415, 'Lambcasing', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 51385941982, 7.29, 'suspendisse');
insert into items (uuid, name, description, barcode, price, make) values (416, 'Beer - Camerons Cream Ale', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 79148189793, 35.61, 'eget');
insert into items (uuid, name, description, barcode, price, make) values (417, 'Jagermeister', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 76272574867, 6.36, 'potenti');
insert into items (uuid, name, description, barcode, price, make) values (418, 'Table Cloth 62x114 White', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 55076618608, 6.12, 'ipsum');
insert into items (uuid, name, description, barcode, price, make) values (419, 'Skirt - 24 Foot', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 90183816074, 7.06, 'tristique');
insert into items (uuid, name, description, barcode, price, make) values (420, 'Paste - Black Olive', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 33097426061, 16.17, 'diam');
insert into items (uuid, name, description, barcode, price, make) values (421, 'Wine - Savigny - Les - Beaune', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 44825824668, 41.12, 'integer');
insert into items (uuid, name, description, barcode, price, make) values (422, 'Turkey - Ground. Lean', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 39321452799, 8.38, 'lorem');
insert into items (uuid, name, description, barcode, price, make) values (423, 'Hot Choc Vending', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 24307483723, 36.17, 'in');
insert into items (uuid, name, description, barcode, price, make) values (424, 'Chips - Doritos', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 24602895347, 27.51, 'varius');
insert into items (uuid, name, description, barcode, price, make) values (425, 'Juice - Prune', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 58301928441, 22.0, 'integer');
insert into items (uuid, name, description, barcode, price, make) values (426, 'Wine - Beringer Founders Estate', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 82713953295, 29.91, 'curae');
insert into items (uuid, name, description, barcode, price, make) values (427, 'Sugar - Brown, Individual', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 98461010246, 41.9, 'justo');
insert into items (uuid, name, description, barcode, price, make) values (428, 'Muffin Batt - Choc Chk', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 58933938841, 7.85, 'eleifend');
insert into items (uuid, name, description, barcode, price, make) values (429, 'Ecolab Silver Fusion', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 26438446131, 32.64, 'quis');
insert into items (uuid, name, description, barcode, price, make) values (430, 'Wine - Acient Coast Caberne', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 51543235821, 34.62, 'ipsum');
insert into items (uuid, name, description, barcode, price, make) values (431, 'Vanilla Beans', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 66953956739, 29.47, 'id');
insert into items (uuid, name, description, barcode, price, make) values (432, 'Wine - Balbach Riverside', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 60431083482, 23.71, 'eget');
insert into items (uuid, name, description, barcode, price, make) values (433, 'Compound - Raspberry', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 82648409733, 19.08, 'commodo');
insert into items (uuid, name, description, barcode, price, make) values (434, 'Longos - Lasagna Veg', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 49766311101, 40.3, 'feugiat');
insert into items (uuid, name, description, barcode, price, make) values (435, 'Mushroom - Chanterelle Frozen', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 84965625733, 11.0, 'quis');
insert into items (uuid, name, description, barcode, price, make) values (436, 'Raspberries - Fresh', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 19794424148, 29.04, 'placerat');
insert into items (uuid, name, description, barcode, price, make) values (437, 'Doilies - 7, Paper', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 88173654946, 17.1, 'lobortis');
insert into items (uuid, name, description, barcode, price, make) values (438, 'Pepper - Cayenne', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.

Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 73330411991, 45.32, 'porttitor');
insert into items (uuid, name, description, barcode, price, make) values (439, 'Macaroons - Homestyle Two Bit', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 97620365432, 46.93, 'non');
insert into items (uuid, name, description, barcode, price, make) values (440, 'Sprouts Dikon', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 98261236519, 14.13, 'nec');
insert into items (uuid, name, description, barcode, price, make) values (441, 'Beef - Short Ribs', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 31379567240, 27.16, 'blandit');
insert into items (uuid, name, description, barcode, price, make) values (442, 'Blueberries - Frozen', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 82567665399, 47.14, 'ultrices');
insert into items (uuid, name, description, barcode, price, make) values (443, 'Pepper - Jalapeno', 'Fusce consequat. Nulla nisl. Nunc nisl.', 37051692598, 9.62, 'id');
insert into items (uuid, name, description, barcode, price, make) values (444, 'Mushroom - Lg - Cello', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 36541304077, 30.7, 'congue');
insert into items (uuid, name, description, barcode, price, make) values (445, 'Pastry - Key Limepoppy Seed Tea', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 94401420713, 3.06, 'pede');
insert into items (uuid, name, description, barcode, price, make) values (446, 'Cake - Miini Cheesecake Cherry', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 93705168202, 25.26, 'suspendisse');
insert into items (uuid, name, description, barcode, price, make) values (447, 'Coffee - Egg Nog Capuccino', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 69788655619, 5.99, 'vehicula');
insert into items (uuid, name, description, barcode, price, make) values (448, 'Nougat - Paste / Cream', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 75737391955, 8.9, 'in');
insert into items (uuid, name, description, barcode, price, make) values (449, 'Salt - Celery', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 65570212707, 23.95, 'sagittis');
insert into items (uuid, name, description, barcode, price, make) values (450, 'Chocolate - Chips Compound', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 32521827187, 4.98, 'quis');
insert into items (uuid, name, description, barcode, price, make) values (451, 'Cheese - Brie,danish', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 23913117962, 19.78, 'eget');
insert into items (uuid, name, description, barcode, price, make) values (452, 'Latex Rubber Gloves Size 9', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 26712147756, 45.7, 'pharetra');
insert into items (uuid, name, description, barcode, price, make) values (453, 'Chivas Regal - 12 Year Old', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 37816653730, 15.58, 'libero');
insert into items (uuid, name, description, barcode, price, make) values (454, 'Table Cloth 53x69 White', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', 82593284609, 15.67, 'non');
insert into items (uuid, name, description, barcode, price, make) values (455, 'Beef - Ground Medium', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 93236044839, 10.94, 'in');
insert into items (uuid, name, description, barcode, price, make) values (456, 'Chips - Doritos', 'In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 90704081105, 1.13, 'odio');
insert into items (uuid, name, description, barcode, price, make) values (457, 'Beef - Bones, Marrow', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 55111763056, 18.03, 'amet');
insert into items (uuid, name, description, barcode, price, make) values (458, 'Yogurt - Strawberry, 175 Gr', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 19382107608, 40.86, 'enim');
insert into items (uuid, name, description, barcode, price, make) values (459, 'Breakfast Quesadillas', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 36782831222, 33.23, 'sed');
insert into items (uuid, name, description, barcode, price, make) values (460, 'Crackers - Soda / Saltins', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 29979481193, 42.32, 'mauris');
insert into items (uuid, name, description, barcode, price, make) values (461, 'Sauce - Cranberry', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 59972847957, 11.48, 'nullam');
insert into items (uuid, name, description, barcode, price, make) values (462, 'Muffin - Mix - Mango Sour Cherry', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 41429575780, 31.23, 'gravida');
insert into items (uuid, name, description, barcode, price, make) values (463, 'Myers Planters Punch', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 29192209396, 21.82, 'purus');
insert into items (uuid, name, description, barcode, price, make) values (464, 'Beer - Labatt Blue', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 34960517785, 25.77, 'volutpat');
insert into items (uuid, name, description, barcode, price, make) values (465, 'Wine - Mondavi Coastal Private', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.', 37753753925, 14.93, 'molestie');
insert into items (uuid, name, description, barcode, price, make) values (466, 'Green Tea Refresher', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 62870664749, 18.41, 'iaculis');
insert into items (uuid, name, description, barcode, price, make) values (467, 'Yeast - Fresh, Fleischman', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 13860893434, 18.15, 'at');
insert into items (uuid, name, description, barcode, price, make) values (468, 'Jameson Irish Whiskey', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', 59166015104, 29.8, 'pede');
insert into items (uuid, name, description, barcode, price, make) values (469, 'Pepper - Sorrano', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 50324685124, 23.54, 'mus');
insert into items (uuid, name, description, barcode, price, make) values (470, 'Oil - Truffle, Black', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 99798884335, 42.21, 'erat');
insert into items (uuid, name, description, barcode, price, make) values (471, 'Basil - Primerba, Paste', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 75654396315, 8.29, 'est');
insert into items (uuid, name, description, barcode, price, make) values (472, 'Seedlings - Buckwheat, Organic', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 47558160730, 46.84, 'ultrices');
insert into items (uuid, name, description, barcode, price, make) values (473, 'Napkin - Dinner, White', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 93006181442, 38.13, 'a');
insert into items (uuid, name, description, barcode, price, make) values (474, 'Truffle Cups Green', 'Fusce consequat. Nulla nisl. Nunc nisl.', 98286894954, 22.56, 'eu');
insert into items (uuid, name, description, barcode, price, make) values (475, 'Napkin Colour', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 82943277783, 25.63, 'neque');
insert into items (uuid, name, description, barcode, price, make) values (476, 'Beef - Chuck, Boneless', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 52858303913, 12.7, 'nunc');
insert into items (uuid, name, description, barcode, price, make) values (477, 'Cheese - Blue', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 95104164521, 7.79, 'quis');
insert into items (uuid, name, description, barcode, price, make) values (478, 'Lid - 0090 Clear', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 18509927411, 12.49, 'massa');
insert into items (uuid, name, description, barcode, price, make) values (479, 'Salt And Pepper Mix - Black', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 19842174132, 42.81, 'sed');
insert into items (uuid, name, description, barcode, price, make) values (480, 'Cookies Almond Hazelnut', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 85808145015, 46.2, 'turpis');
insert into items (uuid, name, description, barcode, price, make) values (481, 'Pike - Frozen Fillet', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 38772324050, 11.06, 'praesent');
insert into items (uuid, name, description, barcode, price, make) values (482, 'Ecolab - Solid Fusion', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 90693016471, 44.72, 'libero');
insert into items (uuid, name, description, barcode, price, make) values (483, 'Tea - Orange Pekoe', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 47496362452, 27.3, 'semper');
insert into items (uuid, name, description, barcode, price, make) values (484, 'Stock - Veal, Brown', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 24989255087, 31.92, 'nisi');
insert into items (uuid, name, description, barcode, price, make) values (485, 'Soup - Campbells, Creamy', 'Fusce consequat. Nulla nisl. Nunc nisl.', 43729546600, 44.54, 'luctus');
insert into items (uuid, name, description, barcode, price, make) values (486, 'Soup - Chicken And Wild Rice', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 89424450262, 5.87, 'mauris');
insert into items (uuid, name, description, barcode, price, make) values (487, 'Paste - Black Olive', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 87457763762, 39.86, 'consequat');
insert into items (uuid, name, description, barcode, price, make) values (488, 'V8 Splash Strawberry Kiwi', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 26008758012, 31.03, 'lectus');
insert into items (uuid, name, description, barcode, price, make) values (489, 'Salt - Table', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 37426552072, 46.66, 'turpis');
insert into items (uuid, name, description, barcode, price, make) values (490, 'Tilapia - Fillets', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', 53969877313, 48.78, 'eu');
insert into items (uuid, name, description, barcode, price, make) values (491, 'Shrimp - Prawn', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 71427075249, 23.5, 'sapien');
insert into items (uuid, name, description, barcode, price, make) values (492, 'Ranchero - Primerba, Paste', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 34398034181, 42.19, 'tincidunt');
insert into items (uuid, name, description, barcode, price, make) values (493, 'Tart Shells - Sweet, 3', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 64066018761, 24.89, 'curabitur');
insert into items (uuid, name, description, barcode, price, make) values (494, 'Rice Paper', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 46698829702, 11.06, 'lectus');
insert into items (uuid, name, description, barcode, price, make) values (495, 'Juice - Tomato, 48 Oz', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 49114861816, 32.18, 'rutrum');
insert into items (uuid, name, description, barcode, price, make) values (496, 'Pop Shoppe Cream Soda', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 98371692573, 12.64, 'justo');
insert into items (uuid, name, description, barcode, price, make) values (497, 'Pastry - Plain Baked Croissant', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 85977375842, 24.13, 'donec');
insert into items (uuid, name, description, barcode, price, make) values (498, 'Cheese - Oka', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 97151123634, 41.73, 'aliquet');
insert into items (uuid, name, description, barcode, price, make) values (499, 'Pie Pecan', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 30451371031, 21.17, 'erat');
insert into items (uuid, name, description, barcode, price, make) values (500, 'Bread - English Muffin', 'In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 80420323298, 39.59, 'orci');


insert into transactions (uuid, token, user_uuid) values (1, '13vap5E7W7NcW1Hez6tqH9GX393FQK3pcS', 32);
insert into transactions (uuid, token, user_uuid) values (2, '1HGrZUVvSMGnPKAPkhcrrFr73TYdrUXoCv', 4);
insert into transactions (uuid, token, user_uuid) values (3, '1J6kQixc4YAZHbSVCZok8osMEeQ9Kk1oDG', 8);
insert into transactions (uuid, token, user_uuid) values (4, '17cgX3URPDLZJwVF5tSaHneWZrwyNbfFqw', 33);
insert into transactions (uuid, token, user_uuid) values (5, '1Pi8kebiePBmu6Byhbgs2fBUGqVxDXV4DC', 46);
insert into transactions (uuid, token, user_uuid) values (6, '1NQsR9MswyKHCm6EXPjQZTVzBk9AonNQXr', 9);
insert into transactions (uuid, token, user_uuid) values (7, '1LfNtHs1YeYdswiwNQ7nkBiesjjYPKu1BV', 15);
insert into transactions (uuid, token, user_uuid) values (8, '19vfJABeaM718jsr2zJdh4NvM4YsDtGztX', 30);
insert into transactions (uuid, token, user_uuid) values (9, '12VUxBoMaCDdjByztg3Xx62TZ5MnYV3nj8', 47);
insert into transactions (uuid, token, user_uuid) values (10, '1ApvkrWKdy3sDTUGfkse1G1ywG9MBT17wi', 9);
insert into transactions (uuid, token, user_uuid) values (11, '1KboUW2ns9MroCzW4EXrjcG75JN4MDrDdn', 19);
insert into transactions (uuid, token, user_uuid) values (12, '15JhYCiEq3AgHZbVP3FGFJdXttxDapWePF', 35);
insert into transactions (uuid, token, user_uuid) values (13, '1K7bLj5KaNq1TAVathxuiqtf5xWf6tde9h', 8);
insert into transactions (uuid, token, user_uuid) values (14, '1CacwAcX1boUJD6TK86RbAZz6eJyaTCRVR', 4);
insert into transactions (uuid, token, user_uuid) values (15, '1DytxHoFKSVNmeBve1xuo63t8JsKAYuaBj', 16);
insert into transactions (uuid, token, user_uuid) values (16, '17BMfLATxvzUC7FfjBtJPMsh7bCWJpSxAk', 10);
insert into transactions (uuid, token, user_uuid) values (17, '1L4BvpHQ8XT46RYNpZEkHf21p8SRK5WaT5', 16);
insert into transactions (uuid, token, user_uuid) values (18, '1KfWc2ftMBwDW5wGvJXxVoZ8WReq7tK9Z1', 43);
insert into transactions (uuid, token, user_uuid) values (19, '1G1GbP4cGoMsbEf9SSRot6c7mpZ8gFLdu2', 14);
insert into transactions (uuid, token, user_uuid) values (20, '1YEcdtPXxDiv2famMqgQv9HN9zSDSciPW', 47);

insert into transaction_items (transaction_uuid, item_uuid) values (20, 390);
insert into transaction_items (transaction_uuid, item_uuid) values (1, 141);
insert into transaction_items (transaction_uuid, item_uuid) values (4, 402);
insert into transaction_items (transaction_uuid, item_uuid) values (1, 182);
insert into transaction_items (transaction_uuid, item_uuid) values (8, 81);
insert into transaction_items (transaction_uuid, item_uuid) values (10, 158);
insert into transaction_items (transaction_uuid, item_uuid) values (18, 85);
insert into transaction_items (transaction_uuid, item_uuid) values (12, 120);
insert into transaction_items (transaction_uuid, item_uuid) values (12, 13);
insert into transaction_items (transaction_uuid, item_uuid) values (8, 225);
insert into transaction_items (transaction_uuid, item_uuid) values (14, 278);
insert into transaction_items (transaction_uuid, item_uuid) values (17, 354);
insert into transaction_items (transaction_uuid, item_uuid) values (5, 413);
insert into transaction_items (transaction_uuid, item_uuid) values (19, 420);
insert into transaction_items (transaction_uuid, item_uuid) values (12, 451);
insert into transaction_items (transaction_uuid, item_uuid) values (19, 76);
insert into transaction_items (transaction_uuid, item_uuid) values (16, 291);
insert into transaction_items (transaction_uuid, item_uuid) values (9, 139);
insert into transaction_items (transaction_uuid, item_uuid) values (18, 266);
insert into transaction_items (transaction_uuid, item_uuid) values (18, 485);
insert into transaction_items (transaction_uuid, item_uuid) values (11, 491);
insert into transaction_items (transaction_uuid, item_uuid) values (7, 294);
insert into transaction_items (transaction_uuid, item_uuid) values (7, 412);
insert into transaction_items (transaction_uuid, item_uuid) values (7, 248);
insert into transaction_items (transaction_uuid, item_uuid) values (18, 15);
insert into transaction_items (transaction_uuid, item_uuid) values (8, 130);
insert into transaction_items (transaction_uuid, item_uuid) values (10, 470);
insert into transaction_items (transaction_uuid, item_uuid) values (19, 342);
insert into transaction_items (transaction_uuid, item_uuid) values (15, 388);
insert into transaction_items (transaction_uuid, item_uuid) values (9, 410);
insert into transaction_items (transaction_uuid, item_uuid) values (3, 75);
insert into transaction_items (transaction_uuid, item_uuid) values (11, 19);
insert into transaction_items (transaction_uuid, item_uuid) values (1, 403);
insert into transaction_items (transaction_uuid, item_uuid) values (19, 83);
insert into transaction_items (transaction_uuid, item_uuid) values (5, 134);
insert into transaction_items (transaction_uuid, item_uuid) values (2, 326);
insert into transaction_items (transaction_uuid, item_uuid) values (8, 272);
insert into transaction_items (transaction_uuid, item_uuid) values (20, 40);
insert into transaction_items (transaction_uuid, item_uuid) values (19, 102);
insert into transaction_items (transaction_uuid, item_uuid) values (13, 41);
insert into transaction_items (transaction_uuid, item_uuid) values (9, 338);
insert into transaction_items (transaction_uuid, item_uuid) values (10, 1);
insert into transaction_items (transaction_uuid, item_uuid) values (12, 16);
insert into transaction_items (transaction_uuid, item_uuid) values (11, 337);
insert into transaction_items (transaction_uuid, item_uuid) values (16, 422);
insert into transaction_items (transaction_uuid, item_uuid) values (20, 306);
insert into transaction_items (transaction_uuid, item_uuid) values (8, 99);
insert into transaction_items (transaction_uuid, item_uuid) values (4, 238);
insert into transaction_items (transaction_uuid, item_uuid) values (15, 194);
insert into transaction_items (transaction_uuid, item_uuid) values (7, 456);
insert into transaction_items (transaction_uuid, item_uuid) values (20, 273);
insert into transaction_items (transaction_uuid, item_uuid) values (8, 462);
insert into transaction_items (transaction_uuid, item_uuid) values (10, 286);
insert into transaction_items (transaction_uuid, item_uuid) values (15, 166);
insert into transaction_items (transaction_uuid, item_uuid) values (15, 110);
insert into transaction_items (transaction_uuid, item_uuid) values (19, 385);
insert into transaction_items (transaction_uuid, item_uuid) values (2, 224);
insert into transaction_items (transaction_uuid, item_uuid) values (20, 415);
insert into transaction_items (transaction_uuid, item_uuid) values (1, 75);
insert into transaction_items (transaction_uuid, item_uuid) values (17, 440);
insert into transaction_items (transaction_uuid, item_uuid) values (3, 156);
insert into transaction_items (transaction_uuid, item_uuid) values (14, 224);
insert into transaction_items (transaction_uuid, item_uuid) values (11, 31);
insert into transaction_items (transaction_uuid, item_uuid) values (15, 355);
insert into transaction_items (transaction_uuid, item_uuid) values (19, 75);
insert into transaction_items (transaction_uuid, item_uuid) values (3, 12);
insert into transaction_items (transaction_uuid, item_uuid) values (13, 13);
insert into transaction_items (transaction_uuid, item_uuid) values (18, 303);
insert into transaction_items (transaction_uuid, item_uuid) values (8, 343);
insert into transaction_items (transaction_uuid, item_uuid) values (16, 258);
insert into transaction_items (transaction_uuid, item_uuid) values (19, 380);
insert into transaction_items (transaction_uuid, item_uuid) values (12, 246);
insert into transaction_items (transaction_uuid, item_uuid) values (14, 167);
insert into transaction_items (transaction_uuid, item_uuid) values (19, 120);
insert into transaction_items (transaction_uuid, item_uuid) values (4, 275);
insert into transaction_items (transaction_uuid, item_uuid) values (17, 22);
insert into transaction_items (transaction_uuid, item_uuid) values (18, 93);
insert into transaction_items (transaction_uuid, item_uuid) values (2, 410);
insert into transaction_items (transaction_uuid, item_uuid) values (4, 255);
insert into transaction_items (transaction_uuid, item_uuid) values (4, 51);
insert into transaction_items (transaction_uuid, item_uuid) values (3, 96);
insert into transaction_items (transaction_uuid, item_uuid) values (10, 116);
insert into transaction_items (transaction_uuid, item_uuid) values (14, 149);
insert into transaction_items (transaction_uuid, item_uuid) values (5, 304);
insert into transaction_items (transaction_uuid, item_uuid) values (2, 138);
insert into transaction_items (transaction_uuid, item_uuid) values (3, 263);
insert into transaction_items (transaction_uuid, item_uuid) values (17, 305);
insert into transaction_items (transaction_uuid, item_uuid) values (2, 337);
insert into transaction_items (transaction_uuid, item_uuid) values (20, 495);
insert into transaction_items (transaction_uuid, item_uuid) values (11, 253);
insert into transaction_items (transaction_uuid, item_uuid) values (15, 358);
insert into transaction_items (transaction_uuid, item_uuid) values (1, 404);
insert into transaction_items (transaction_uuid, item_uuid) values (10, 312);
insert into transaction_items (transaction_uuid, item_uuid) values (9, 235);
insert into transaction_items (transaction_uuid, item_uuid) values (4, 439);
insert into transaction_items (transaction_uuid, item_uuid) values (1, 104);
insert into transaction_items (transaction_uuid, item_uuid) values (8, 50);
insert into transaction_items (transaction_uuid, item_uuid) values (1, 87);
insert into transaction_items (transaction_uuid, item_uuid) values (13, 390);
insert into transaction_items (transaction_uuid, item_uuid) values (8, 312);
insert into transaction_items (transaction_uuid, item_uuid) values (5, 18);
insert into transaction_items (transaction_uuid, item_uuid) values (17, 263);
insert into transaction_items (transaction_uuid, item_uuid) values (8, 127);
insert into transaction_items (transaction_uuid, item_uuid) values (18, 286);
insert into transaction_items (transaction_uuid, item_uuid) values (16, 65);
insert into transaction_items (transaction_uuid, item_uuid) values (16, 224);
insert into transaction_items (transaction_uuid, item_uuid) values (10, 306);
insert into transaction_items (transaction_uuid, item_uuid) values (12, 17);
insert into transaction_items (transaction_uuid, item_uuid) values (2, 80);
insert into transaction_items (transaction_uuid, item_uuid) values (13, 325);
insert into transaction_items (transaction_uuid, item_uuid) values (1, 292);
insert into transaction_items (transaction_uuid, item_uuid) values (17, 373);
insert into transaction_items (transaction_uuid, item_uuid) values (13, 334);
insert into transaction_items (transaction_uuid, item_uuid) values (17, 379);
insert into transaction_items (transaction_uuid, item_uuid) values (12, 481);
insert into transaction_items (transaction_uuid, item_uuid) values (12, 31);
insert into transaction_items (transaction_uuid, item_uuid) values (19, 131);
insert into transaction_items (transaction_uuid, item_uuid) values (2, 363);
insert into transaction_items (transaction_uuid, item_uuid) values (11, 195);
insert into transaction_items (transaction_uuid, item_uuid) values (13, 430);
insert into transaction_items (transaction_uuid, item_uuid) values (19, 374);
insert into transaction_items (transaction_uuid, item_uuid) values (5, 190);
insert into transaction_items (transaction_uuid, item_uuid) values (11, 417);
insert into transaction_items (transaction_uuid, item_uuid) values (20, 246);
insert into transaction_items (transaction_uuid, item_uuid) values (13, 47);
insert into transaction_items (transaction_uuid, item_uuid) values (17, 303);
insert into transaction_items (transaction_uuid, item_uuid) values (2, 356);
insert into transaction_items (transaction_uuid, item_uuid) values (5, 310);
insert into transaction_items (transaction_uuid, item_uuid) values (15, 225);
insert into transaction_items (transaction_uuid, item_uuid) values (20, 352);
insert into transaction_items (transaction_uuid, item_uuid) values (14, 453);
insert into transaction_items (transaction_uuid, item_uuid) values (10, 354);
insert into transaction_items (transaction_uuid, item_uuid) values (12, 394);
insert into transaction_items (transaction_uuid, item_uuid) values (15, 37);
insert into transaction_items (transaction_uuid, item_uuid) values (19, 171);
insert into transaction_items (transaction_uuid, item_uuid) values (15, 159);
insert into transaction_items (transaction_uuid, item_uuid) values (11, 115);
insert into transaction_items (transaction_uuid, item_uuid) values (15, 359);
insert into transaction_items (transaction_uuid, item_uuid) values (6, 169);
insert into transaction_items (transaction_uuid, item_uuid) values (2, 228);
insert into transaction_items (transaction_uuid, item_uuid) values (19, 376);
insert into transaction_items (transaction_uuid, item_uuid) values (2, 308);
insert into transaction_items (transaction_uuid, item_uuid) values (1, 59);
insert into transaction_items (transaction_uuid, item_uuid) values (10, 136);
insert into transaction_items (transaction_uuid, item_uuid) values (6, 323);
insert into transaction_items (transaction_uuid, item_uuid) values (7, 26);
insert into transaction_items (transaction_uuid, item_uuid) values (4, 365);
insert into transaction_items (transaction_uuid, item_uuid) values (8, 71);
insert into transaction_items (transaction_uuid, item_uuid) values (11, 316);
insert into transaction_items (transaction_uuid, item_uuid) values (10, 61);
insert into transaction_items (transaction_uuid, item_uuid) values (10, 56);
insert into transaction_items (transaction_uuid, item_uuid) values (14, 500);
insert into transaction_items (transaction_uuid, item_uuid) values (17, 389);
insert into transaction_items (transaction_uuid, item_uuid) values (14, 83);
insert into transaction_items (transaction_uuid, item_uuid) values (18, 312);
insert into transaction_items (transaction_uuid, item_uuid) values (16, 216);
insert into transaction_items (transaction_uuid, item_uuid) values (3, 478);
insert into transaction_items (transaction_uuid, item_uuid) values (12, 19);
insert into transaction_items (transaction_uuid, item_uuid) values (10, 351);
insert into transaction_items (transaction_uuid, item_uuid) values (9, 287);
insert into transaction_items (transaction_uuid, item_uuid) values (2, 135);
insert into transaction_items (transaction_uuid, item_uuid) values (11, 48);
insert into transaction_items (transaction_uuid, item_uuid) values (6, 251);
insert into transaction_items (transaction_uuid, item_uuid) values (5, 161);
insert into transaction_items (transaction_uuid, item_uuid) values (17, 301);
insert into transaction_items (transaction_uuid, item_uuid) values (1, 236);
insert into transaction_items (transaction_uuid, item_uuid) values (4, 460);
insert into transaction_items (transaction_uuid, item_uuid) values (13, 86);
insert into transaction_items (transaction_uuid, item_uuid) values (18, 498);
insert into transaction_items (transaction_uuid, item_uuid) values (3, 46);
insert into transaction_items (transaction_uuid, item_uuid) values (8, 15);
insert into transaction_items (transaction_uuid, item_uuid) values (14, 388);
insert into transaction_items (transaction_uuid, item_uuid) values (16, 142);
insert into transaction_items (transaction_uuid, item_uuid) values (13, 40);
insert into transaction_items (transaction_uuid, item_uuid) values (17, 164);
insert into transaction_items (transaction_uuid, item_uuid) values (13, 325);
insert into transaction_items (transaction_uuid, item_uuid) values (3, 27);
insert into transaction_items (transaction_uuid, item_uuid) values (3, 454);
insert into transaction_items (transaction_uuid, item_uuid) values (5, 211);
insert into transaction_items (transaction_uuid, item_uuid) values (10, 461);
insert into transaction_items (transaction_uuid, item_uuid) values (14, 249);
insert into transaction_items (transaction_uuid, item_uuid) values (12, 161);
insert into transaction_items (transaction_uuid, item_uuid) values (15, 25);
insert into transaction_items (transaction_uuid, item_uuid) values (1, 468);
insert into transaction_items (transaction_uuid, item_uuid) values (1, 239);
insert into transaction_items (transaction_uuid, item_uuid) values (6, 178);
insert into transaction_items (transaction_uuid, item_uuid) values (3, 216);
insert into transaction_items (transaction_uuid, item_uuid) values (2, 461);
insert into transaction_items (transaction_uuid, item_uuid) values (3, 240);
insert into transaction_items (transaction_uuid, item_uuid) values (6, 227);
insert into transaction_items (transaction_uuid, item_uuid) values (16, 115);
insert into transaction_items (transaction_uuid, item_uuid) values (17, 445);
insert into transaction_items (transaction_uuid, item_uuid) values (14, 285);
insert into transaction_items (transaction_uuid, item_uuid) values (12, 491);
insert into transaction_items (transaction_uuid, item_uuid) values (3, 292);
insert into transaction_items (transaction_uuid, item_uuid) values (8, 238);
insert into transaction_items (transaction_uuid, item_uuid) values (15, 248);
insert into transaction_items (transaction_uuid, item_uuid) values (16, 319);
insert into transaction_items (transaction_uuid, item_uuid) values (19, 227);
insert into transaction_items (transaction_uuid, item_uuid) values (2, 298);
