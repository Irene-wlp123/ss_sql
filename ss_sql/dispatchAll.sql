SELECT a.*,( CASE WHEN a.subRate IS NULL THEN a.purchasePrice WHEN a.subRate IS NOT NULL THEN a.subPurchasePrice END ) money
FROM
    (
        SELECT
            concat( 'dispatch', b.id ) itemId,
            now() ods_updateTime,
            a.arrival_type as arrivalType,
            ss.NO outCode,
            ss.NAME outName,
            ss.id outId,
            a.order_no orderNo,
            a.in_unit inCode,
            e.NAME inName,
            e.id inId,
            b.product_no productNo,
            b.product_name productname,
            b.size_code sizeCode,
            b.color_code colorCode,
            d.size_name sizeName,
            c.color_name colorname,
            fp.category_id cateId,
            fp.cateName,
            fp.sale_price standardPrice,
            b.purchase_price purchasePrice,
            b.sub_purchase_price subPurchasePrice,
            fps.season_code seasonCode,
            fps.NAME seasonName,
            sum( case
                     when b.input_num is not null then b.input_num
                     when b.input_num is null then b.num
                end
                ) totalNum,
            a.out_stock_time outStockTime,
            ( SELECT uid FROM sys_tenant f WHERE f.unit_code = a.out_unit ) outUid,
            ( SELECT uid FROM sys_tenant f WHERE f.unit_code = a.in_unit ) inUid,
            substr( `fps`.`name`, 1, 4 ) years,
            substr( `fps`.`name`, 5, 2 ) season,
            sub_rate AS subRate,
            a.remarks as remarks
        FROM
            se_order a
                LEFT JOIN se_order_item b ON a.id = b.order_id
                LEFT JOIN fp_product_color c ON b.color_code = c.color_code
                LEFT JOIN fp_product_size d ON b.size_code = d.size_code
                AND d.size_group = '01'
                LEFT JOIN ums_store e ON a.in_unit = e.unit_code
                LEFT JOIN fp_product fp ON b.product_no = fp.
                NO LEFT JOIN fp_product_season fps ON fps.season_code = fp.season_code
                LEFT JOIN sys_organization ss ON ss.NO = a.out_unit
        WHERE
                a.delete_status = 0
          AND a.order_state > 3
          AND a.flow_type = 1
          AND a.order_type = 'D'
          AND a.out_stock_time BETWEEN DATE_SUB( now(), INTERVAL 1000000 HOUR )
            AND now()
        GROUP BY
            a.in_unit,
            ss.id,
            b.id,
            ss.NO,
            ss.NAME,
            e.NAME,
            b.product_no,
            b.product_name,
            b.size_code,
            b.color_code,
            d.size_name,
            e.NAME,
            e.id,
            fp.category_id,
            fp.cateName,
            fp.sale_price,
            b.purchase_price,
            fps.season_code,
            fps.NAME,
            a.order_no,
            c.color_name,
            date_format( a.out_stock_time, '%Y-%m-%d' ),
            outUid,
            inUid,
            a.remarks
        UNION
        SELECT
            concat( 'dispatch', b.id ) itemId,
            now() ods_updateTime,
            a.arrival_type as arrivalType,
            ss.NO outCode,
            ss.NAME outName,
            ss.id outId,
            a.order_no orderNo,
            a.in_unit inCode,
            e.NAME inName,
            e.id inId,
            b.product_no productNo,
            b.product_name productname,
            b.size_code sizeCode,
            b.color_code colorCode,
            d.size_name sizeName,
            c.color_name colorname,
            fp.category_id cateId,
            fp.cateName,
            fp.sale_price standardPrice,
            b.purchase_price purchasePrice,
            b.sub_purchase_price subPurchasePrice,
            fps.season_code seasonCode,
            fps.NAME seasonName,
            sum( case
                     when b.input_num is not null then b.input_num
                     when b.input_num is null then b.num
                end
                ) totalNum,
            a.out_stock_time outStockTime,
            ( SELECT uid FROM sys_tenant f WHERE f.unit_code = a.out_unit ) outUid,
            ( SELECT uid FROM sys_tenant f WHERE f.unit_code = a.in_unit ) inUid,
            substr( `fps`.`name`, 1, 4 ) years,
            substr( `fps`.`name`, 5, 2 ) season,
            sub_rate AS subRate ,
            a.remarks as remarks

        FROM
            se_order a
                LEFT JOIN se_order_item b ON a.id = b.order_id
                LEFT JOIN fp_product_color c ON b.color_code = c.color_code
                LEFT JOIN fp_product_size d ON b.size_code = d.size_code
                AND d.size_group = '01'
                LEFT JOIN sys_organization e ON a.in_unit = e.
                NO LEFT JOIN fp_product fp ON b.product_no = fp.
                NO LEFT JOIN fp_product_season fps ON fps.season_code = fp.season_code
                LEFT JOIN sys_organization ss ON ss.NO = a.out_unit
        WHERE
                a.delete_status = 0
          AND a.order_state > 3
          AND a.flow_type = 2
          AND a.order_type = 'D'
          AND a.out_stock_time BETWEEN DATE_SUB( now(), INTERVAL 1000000 HOUR )
            AND now()
        GROUP BY
            a.in_unit,
            ss.id,
            ss.NO,
            ss.NAME,
            e.NAME,
            b.product_no,
            b.product_name,
            b.size_code,
            b.color_code,
            d.size_name,
            e.NAME,
            e.id,
            fp.category_id,
            fp.cateName,
            fp.sale_price,
            b.purchase_price,
            fps.season_code,
            fps.NAME,
            a.order_no,
            c.color_name,
            date_format( a.out_stock_time, '%Y-%m-%d' ),
            outUid,
            inUid,
            a.remarks
    ) a