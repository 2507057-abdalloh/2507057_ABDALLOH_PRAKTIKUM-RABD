create database praktikum_transaksi;
use praktikum_transaksi;

create table rekening (
	id int primary key,
	nama varchar(50) not null,
	saldo decimal(12,2) not null,
	constraint chk_saldo_nonegatif check (saldo >= 0)
	) engine=InnoDB;

insert into rekening (id, nama, saldo) values
	(1, 'Budi', 500000.00),
	(2, 'Siti', 250000.00);

select * from rekening;

SCRIPT 1: TRANSAKSI DENGAN commit

START TRANSACTION;

UPDATE rekening 
SET saldo = saldo - 100000.00 
WHERE id = 1;

UPDATE rekening 
SET saldo = saldo + 100000.00 
WHERE id = 2;

SELECT id, nama, saldo 
FROM rekening 
ORDER BY id;

COMMIT; 

SCRIPT 2: MEMBATALKAN TRANSAKSI DENGAN rollback 

select * from rekening;

start transaction;

update rekening
set saldo = saldo - 50000
where id = 1;

select * from rekening;

rollback;

SCRIPT 3: savepoint UNTUK PEMBATALAN SEBAGIAN 

start transaction;

update rekening
set saldo = saldo - 50000
where id = 1;

update rekening
set saldo = saldo + 50000
where id = 2;

savepoint setelah_transfer;

update rekening
set saldo = saldo - 10000
where id = 1;

rollback to savepoint setelah_transfer;

commit;

select * from rekening;

SCRIPT 4: LEPASKAN savepoint DENGAN release savepoint

start transaction;

update rekening
set saldo = saldo - 10000
where id = 1;

savepoint sp_pemeriksaan;

update rekening
set saldo = saldo + 10000
where id = 2;

release savepoint sp_pemeriksaan;

commit;
select * from rekening;

SCRIPT 5: savepoint BERTINGKAT DAN SKENARIO PEMULIHAN

STEP 1:
start transaction;

update rekening
set saldo = saldo + 20000
where id = 1;

savepoint sp_awal;

STEP 2:
update rekening
set saldo = saldo + 20000
where id = 2;

savepoint sp_kedua;

STEP TAMBAHAN:
update rekening
set saldo = saldo - 5000
where id = 1;

BATALKAN HANYA KE OPERASI SETELAH sp_kedua:
rollback to savepoint sp_kedua;

HAPUS PENANDA YANG TIDAK DIPERLUKAN:
release savepoint sp_kedua;

commit;

select * from rekening;
