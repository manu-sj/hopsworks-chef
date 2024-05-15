-- HWORKS-987
ALTER TABLE `hopsworks`.`model_version` ADD CONSTRAINT `model_version_key` UNIQUE (`model_id`,`version`);
ALTER TABLE `hopsworks`.`model_version` DROP PRIMARY KEY;
ALTER TABLE `hopsworks`.`model_version` ADD COLUMN id int(11) AUTO_INCREMENT PRIMARY KEY;

-- FSTORE-1190
ALTER TABLE `hopsworks`.`embedding_feature`
    ADD COLUMN `model_version_id` INT(11) NULL;

ALTER TABLE `hopsworks`.`embedding_feature`
    ADD CONSTRAINT `embedding_feature_model_version_fk` FOREIGN KEY (`model_version_id`) REFERENCES `model_version` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION;

ALTER TABLE `hopsworks`.`serving` ADD COLUMN `api_protocol` TINYINT(1) NOT NULL DEFAULT '0';

-- FSTORE-1096
ALTER TABLE `hopsworks`.`feature_store_jdbc_connector`
    ADD COLUMN `secret_uid` INT DEFAULT NULL,
    ADD COLUMN `secret_name` VARCHAR(200) DEFAULT NULL;

-- FSTORE-1248
ALTER TABLE `hopsworks`.`executions`
    ADD COLUMN `notebook_out_path` varchar(255) COLLATE latin1_general_cs DEFAULT NULL;

CREATE TABLE IF NOT EXISTS `hopsworks`.`model_link` (
  `id` int NOT NULL AUTO_INCREMENT,
  `model_version_id` int(11) NOT NULL,
  `parent_training_dataset_id` int(11),
  `parent_feature_store` varchar(100) NOT NULL,
  `parent_feature_view_name` varchar(63) NOT NULL,
  `parent_feature_view_version` int(11) NOT NULL,
  `parent_training_dataset_version` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `link_unique` (`model_version_id`, `parent_training_dataset_id`),
  KEY `model_version_id_fkc` (`model_version_id`),
  KEY `parent_training_dataset_id_fkc` (`parent_training_dataset_id`),
  CONSTRAINT `model_version_id_fkc` FOREIGN KEY (`model_version_id`) REFERENCES `hopsworks`.`model_version` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `training_dataset_parent_fkc` FOREIGN KEY (`parent_training_dataset_id`) REFERENCES `hopsworks`.`training_dataset` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=ndbcluster DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;

-- FSTORE-920
ALTER TABLE `hopsworks`.`feature_store_jdbc_connector`
    ADD `driver_path` VARCHAR(2000) DEFAULT NULL;
-- FSTORE-1285
ALTER TABLE `hopsworks`.`training_dataset_feature` DROP FOREIGN KEY `tfn_fk_tdf`;
ALTER TABLE `hopsworks`.`training_dataset_feature` DROP `transformation_function`;

ALTER TABLE `hopsworks`.`transformation_function` ADD COLUMN `save_type` VARCHAR(255)    NOT NULL; 

CREATE TABLE IF NOT EXISTS `feature_view_transformation_function` (
    `id`                                INT(11)         NOT NULL AUTO_INCREMENT,
    `transformation_function_id` int(11) NOT NULL,
    `feature_view_id` int(11) NOT NULL,
    `features` VARCHAR(5000) NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `fvtf_fvi_fk` FOREIGN KEY (`feature_view_id`) REFERENCES `feature_view` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fvtf_tfi_fk` FOREIGN KEY (`transformation_function_id`) REFERENCES `transformation_function` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = ndbcluster DEFAULT CHARSET = latin1 COLLATE = latin1_general_cs;