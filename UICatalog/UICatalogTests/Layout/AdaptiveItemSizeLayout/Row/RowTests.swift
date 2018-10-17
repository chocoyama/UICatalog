//
//  RowTests.swift
//  UICatalogTests
//
//  Created by 横山 拓也 on 2018/10/15.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import XCTest
@testable import UICatalog

class RowTests: XCTestCase {
    
    var row: Row!

    func test_正しく初期化されていること() {
        let configuration = AdaptiveWidthConfiguration(
            minimumInterItemSpacing: 0.0,
            minimumLineSpacing: 0.0,
            sectionInsets: .zero
        )
        
        row = Row(
            configuration: configuration,
            section: 1,
            rowNumber: 2,
            height: 50,
            originY: 10.0,
            width: 100
        )
        
        XCTAssertEqual(row.configuration, configuration)
        XCTAssertEqual(row.section, 1)
        XCTAssertEqual(row.number, 2)
        XCTAssertEqual(row.height, 50)
        XCTAssertEqual(row.originY, 10.0)
        XCTAssertEqual(row.width, 100)
    }

    func test_addAttributesを実行すると正しい値でattributesSetのframeとmaxXが更新されること() {
        XCTContext.runActivity(named: "heightが満たない時") { _ in
            row = Row.create(
                configuration: AdaptiveWidthConfiguration(
                    minimumInterItemSpacing: 0.0,
                    minimumLineSpacing: 0.0,
                    sectionInsets: .zero
                ),
                height: 100,
                width: 600
            )
            
            row.addAttributes(
                indexPath: IndexPath(item: 0, section: 0),
                itemSize: CGSize(width: 200, height: 101)
            )
            XCTAssertTrue(row.attributesSet.isEmpty)
            XCTAssertEqual(row.maxX, 0)
        }
        
        XCTContext.runActivity(named: "widthが満たない時") { _ in
            row = Row.create(
                configuration: AdaptiveWidthConfiguration(
                    minimumInterItemSpacing: 0.0,
                    minimumLineSpacing: 0.0,
                    sectionInsets: .zero
                ),
                height: 100,
                width: 600
            )
            
            row.addAttributes(
                indexPath: IndexPath(item: 0, section: 0),
                itemSize: CGSize(width: 601, height: 100)
            )
            XCTAssertTrue(row.attributesSet.isEmpty)
            XCTAssertEqual(row.maxX, 0)
        }
        
        XCTContext.runActivity(named: "セクションマージンとアイテムスペースが0の時") { _ in
            row = Row.create(
                configuration: AdaptiveWidthConfiguration(
                    minimumInterItemSpacing: 0.0,
                    minimumLineSpacing: 0.0,
                    sectionInsets: .zero
                ),
                height: 100,
                width: 600
            )
            
            // 1件目
            row.addAttributes(
                indexPath: IndexPath(item: 0, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            XCTAssertEqual(
                row.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0.0, y: 0.0, width: 200, height: 100)
                ]
            )
            XCTAssertEqual(row.maxX, 200)
            
            // 2件目
            row.addAttributes(
                indexPath: IndexPath(item: 1, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            XCTAssertEqual(
                row.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0.0, y: 0.0, width: 200, height: 100),
                    CGRect(x: 200.0, y: 0.0, width: 200, height: 100)
                ]
            )
            XCTAssertEqual(row.maxX, 400)
            
            // 3件目
            row.addAttributes(
                indexPath: IndexPath(item: 2, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            XCTAssertEqual(
                row.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0.0, y: 0.0, width: 200, height: 100),
                    CGRect(x: 200.0, y: 0.0, width: 200, height: 100),
                    CGRect(x: 400.0, y: 0.0, width: 200, height: 100)
                ]
            )
            XCTAssertEqual(row.maxX, 600)
        }
        
        XCTContext.runActivity(named: "セクションマージンが0の時") { _ in
            row = Row.create(
                configuration: AdaptiveWidthConfiguration(
                    minimumInterItemSpacing: 5.0,
                    minimumLineSpacing: 0.0,
                    sectionInsets: .zero
                ),
                height: 100,
                width: 600
            )
            
            // 1件目
            row.addAttributes(
                indexPath: IndexPath(item: 0, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            XCTAssertEqual(
                row.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0.0, y: 0.0, width: 200, height: 100)
                ]
            )
            XCTAssertEqual(row.maxX, 200)
            
            // 2件目
            row.addAttributes(
                indexPath: IndexPath(item: 1, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            XCTAssertEqual(
                row.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0.0, y: 0.0, width: 200, height: 100),
                    CGRect(x: 205.0, y: 0.0, width: 200, height: 100)
                ]
            )
            XCTAssertEqual(row.maxX, 405)
            
            // 3件目
            row.addAttributes(
                indexPath: IndexPath(item: 2, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            XCTAssertEqual(
                row.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0.0, y: 0.0, width: 200, height: 100),
                    CGRect(x: 205.0, y: 0.0, width: 200, height: 100)
                ]
            )
            XCTAssertEqual(row.maxX, 405)
            
            // 4件目
            row.addAttributes(
                indexPath: IndexPath(item: 3, section: 0),
                itemSize: CGSize(width: 190, height: 100)
            )
            XCTAssertEqual(
                row.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0.0, y: 0.0, width: 200, height: 100),
                    CGRect(x: 205.0, y: 0.0, width: 200, height: 100),
                    CGRect(x: 410.0, y: 0.0, width: 190, height: 100)
                ]
            )
            XCTAssertEqual(row.maxX, 600)
        }
    }
    
}

fileprivate extension Row {
    class func create(
        configuration: AdaptiveWidthConfiguration = .default,
        section: Int = 0,
        rowNumber: Int = 0,
        height: CGFloat = 100,
        originY: CGFloat = 0,
        width: CGFloat = 200
    ) -> Row {
        return Row(
            configuration: configuration,
            section: section,
            rowNumber: rowNumber,
            height: height,
            originY: originY,
            width: width
        )
    }
}
