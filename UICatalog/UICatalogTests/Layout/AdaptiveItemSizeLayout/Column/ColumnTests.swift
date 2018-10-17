//
//  ColumnTests.swift
//  UICatalogTests
//
//  Created by 横山 拓也 on 2018/10/11.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import XCTest
@testable import UICatalog

class ColumnTests: XCTestCase {

    var column: Column!
    
    func test_正しく初期化できていること() {
        let configuration = AdaptiveHeightConfiguration(
            columnCount: 2,
            minColumnCount: 2,
            maxColumnCount: 2,
            minimumInterItemSpacing: 8.0,
            minimumLineSpacing: 5.0,
            sectionInsets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        )
    
        let column = Column(
            configuration: configuration,
            section: 1,
            columnNumber: 2,
            collectionViewWidth: 500
        )

        XCTAssertEqual(column.configuration, configuration)
        XCTAssertEqual(column.section, 1)
        XCTAssertEqual(column.number, 2)
        XCTAssertEqual(column.collectionViewWidth, 500)
    }
    
    func test_widthが正しい値になっていること() {
        XCTContext.runActivity(named: "セクションのマージンとアイテムのスペースが0の時") { _ in
            column = Column.create(
                configuration: .init(
                    columnCount: 1,
                    minimumInterItemSpacing: 0,
                    sectionInsets: .zero
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.width, 200)
            
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 0,
                    sectionInsets: .zero
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.width, 100)
            
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 0,
                    sectionInsets: .zero
                ),
                columnNumber: 1,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.width, 100)
        }
        
        XCTContext.runActivity(named: "セクションのマージンが0の時") { _ in
            column = Column.create(
                configuration: .init(
                    columnCount: 1,
                    minimumInterItemSpacing: 5,
                    sectionInsets: .zero
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.width, 200)
            
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 5,
                    sectionInsets: .zero
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.width, 97.5)
            
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 5,
                    sectionInsets: .zero
                ),
                columnNumber: 1,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.width, 97.5)
        }
        
        XCTContext.runActivity(named: "アイテムのスペースが0の時") { _ in
            column = Column.create(
                configuration: .init(
                    columnCount: 1,
                    minimumInterItemSpacing: 0,
                    sectionInsets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.width, 184)
            
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 0,
                    sectionInsets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.width, 92)
            
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 0,
                    sectionInsets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
                ),
                columnNumber: 1,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.width, 92)
        }
        
        XCTContext.runActivity(named: "セクションのマージンとアイテムのスペースが両方とも0でない時") { _ in
            column = Column.create(
                configuration: .init(
                    columnCount: 1,
                    minimumInterItemSpacing: 5,
                    sectionInsets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.width, 184)
            
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 5,
                    sectionInsets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.width, 89.5)
            
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 5,
                    sectionInsets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
                ),
                columnNumber: 1,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.width, 89.5)
        }
    }
    
    func test_originXが正しい値になっていること() {
        XCTContext.runActivity(named: "セクションのマージンとアイテムのスペースが0の時") { _ in
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 0,
                    sectionInsets: .zero
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.originX, 0)
            
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 0,
                    sectionInsets: .zero
                ),
                columnNumber: 1,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.originX, 100)
        }
        
        XCTContext.runActivity(named: "セクションのマージンが0の時") { _ in
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 5,
                    sectionInsets: .zero
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.originX, 0)
            
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 5,
                    sectionInsets: .zero
                ),
                columnNumber: 1,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.originX, 102.5)
        }
        
        XCTContext.runActivity(named: "アイテムのスペースが0の時") { _ in
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 0,
                    sectionInsets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.originX, 8.0)
            
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 0,
                    sectionInsets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
                ),
                columnNumber: 1,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.originX, 8.0 + 92)
        }
        
        XCTContext.runActivity(named: "セクションのマージンとアイテムのスペースがともに0でない時") { _ in
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 5,
                    sectionInsets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.originX, 8.0)
            
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 5,
                    sectionInsets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
                ),
                columnNumber: 1,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.originX, 8.0 + 89.5 + 5)
        }
    }
    
    func test_maxXが正しい値になっていること() {
        XCTContext.runActivity(named: "セクションのマージンとアイテムのスペースが0の時") { _ in
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 0,
                    sectionInsets: .zero
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.maxX, 100)
            
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 0,
                    sectionInsets: .zero
                ),
                columnNumber: 1,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.maxX, 200)
        }
        
        XCTContext.runActivity(named: "セクションのマージンが0の時") { _ in
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 5,
                    sectionInsets: .zero
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.maxX, 97.5)

            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 5,
                    sectionInsets: .zero
                ),
                columnNumber: 1,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.maxX, 200)
        }

        XCTContext.runActivity(named: "アイテムのスペースが0の時") { _ in
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 0,
                    sectionInsets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.maxX, 100)

            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 0,
                    sectionInsets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
                ),
                columnNumber: 1,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.maxX, 192)
        }

        XCTContext.runActivity(named: "セクションのマージンとアイテムのスペースがともに0でない時") { _ in
            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 5,
                    sectionInsets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.maxX, 8.0 + 89.5)

            column = Column.create(
                configuration: .init(
                    columnCount: 2,
                    minimumInterItemSpacing: 5,
                    sectionInsets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
                ),
                columnNumber: 1,
                collectionViewWidth: 200
            )
            XCTAssertEqual(column.maxX, 192)
        }
    }
    
    func test_addAttributesを実行すると正しい値でattributesSetのframeとmaxYが更新されること() {
        XCTContext.runActivity(named: "セクションのマージンとラインのスペースが0の時") { _ in
            column = Column.create(
                configuration: AdaptiveHeightConfiguration(
                    columnCount: 2,
                    minimumInterItemSpacing: 0,
                    minimumLineSpacing: 0,
                    sectionInsets: .zero
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            
            // 1件目
            column.addAttributes(
                indexPath: IndexPath(item: 0, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            XCTAssertEqual(
                column.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0, y: 0, width: 100, height: 50)
                ]
            )
            XCTAssertEqual(column.maxY, 50)
            XCTAssertEqual(column.height, 50)
            
            // 2件目
            column.addAttributes(
                indexPath: IndexPath(item: 1, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            XCTAssertEqual(
                column.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0, y: 0, width: 100, height: 50),
                    CGRect(x: 0, y: 50, width: 100, height: 50)
                ]
            )
            XCTAssertEqual(column.maxY, 100)
            XCTAssertEqual(column.height, 100)
            
            // 3件目
            column.addAttributes(
                indexPath: IndexPath(item: 2, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            XCTAssertEqual(
                column.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0, y: 0, width: 100, height: 50),
                    CGRect(x: 0, y: 50, width: 100, height: 50),
                    CGRect(x: 0, y: 100, width: 100, height: 50)
                ]
            )
            XCTAssertEqual(column.maxY, 150)
            XCTAssertEqual(column.height, 150)
        }
        
        XCTContext.runActivity(named: "セクションのマージンが0の時") { _ in
            column = Column.create(
                configuration: AdaptiveHeightConfiguration(
                    columnCount: 2,
                    minimumInterItemSpacing: 0,
                    minimumLineSpacing: 5,
                    sectionInsets: .zero
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            
            // 1件目
            column.addAttributes(
                indexPath: IndexPath(item: 0, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            XCTAssertEqual(
                column.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0, y: 0, width: 100, height: 50)
                ]
            )
            XCTAssertEqual(column.maxY, 50)
            XCTAssertEqual(column.height, 50)
            
            // 2件目
            column.addAttributes(
                indexPath: IndexPath(item: 1, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            XCTAssertEqual(
                column.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0, y: 0, width: 100, height: 50),
                    CGRect(x: 0, y: 55, width: 100, height: 50)
                ]
            )
            XCTAssertEqual(column.maxY, 105)
            XCTAssertEqual(column.height, 105)
            
            // 3件目
            column.addAttributes(
                indexPath: IndexPath(item: 2, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            XCTAssertEqual(
                column.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0, y: 0, width: 100, height: 50),
                    CGRect(x: 0, y: 55, width: 100, height: 50),
                    CGRect(x: 0, y: 110, width: 100, height: 50)
                ]
            )
            XCTAssertEqual(column.maxY, 160)
            XCTAssertEqual(column.height, 160)
        }
        
        XCTContext.runActivity(named: "ラインのスペースが0の時") { _ in
            column = Column.create(
                configuration: AdaptiveHeightConfiguration(
                    columnCount: 2,
                    minimumInterItemSpacing: 0,
                    minimumLineSpacing: 0,
                    sectionInsets: UIEdgeInsets(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            
            // 1件目
            column.addAttributes(
                indexPath: IndexPath(item: 0, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            XCTAssertEqual(
                column.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0, y: 8.0, width: 100, height: 50)
                ]
            )
            XCTAssertEqual(column.maxY, 66)
            XCTAssertEqual(column.height, 66)
            
            // 2件目
            column.addAttributes(
                indexPath: IndexPath(item: 1, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            XCTAssertEqual(
                column.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0, y: 8.0, width: 100, height: 50),
                    CGRect(x: 0, y: 58, width: 100, height: 50)
                ]
            )
            XCTAssertEqual(column.maxY, 116)
            XCTAssertEqual(column.height, 116)
            
            // 3件目
            column.addAttributes(
                indexPath: IndexPath(item: 2, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            XCTAssertEqual(
                column.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0, y: 8.0, width: 100, height: 50),
                    CGRect(x: 0, y: 58, width: 100, height: 50),
                    CGRect(x: 0, y: 108, width: 100, height: 50)
                ]
            )
            XCTAssertEqual(column.maxY, 166)
            XCTAssertEqual(column.height, 166)
        }
        
        XCTContext.runActivity(named: "セクションのマージンとラインのスペースが0でない時") { _ in
            column = Column.create(
                configuration: AdaptiveHeightConfiguration(
                    columnCount: 2,
                    minimumInterItemSpacing: 0,
                    minimumLineSpacing: 5,
                    sectionInsets: UIEdgeInsets(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            
            // 1件目
            column.addAttributes(
                indexPath: IndexPath(item: 0, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            XCTAssertEqual(
                column.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0, y: 8.0, width: 100, height: 50)
                ]
            )
            XCTAssertEqual(column.maxY, 66)
            XCTAssertEqual(column.height, 66)
            
            // 2件目
            column.addAttributes(
                indexPath: IndexPath(item: 1, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            XCTAssertEqual(
                column.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0, y: 8.0, width: 100, height: 50),
                    CGRect(x: 0, y: 63, width: 100, height: 50)
                ]
            )
            XCTAssertEqual(column.maxY, 121)
            XCTAssertEqual(column.height, 121)
            
            // 3件目
            column.addAttributes(
                indexPath: IndexPath(item: 2, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            XCTAssertEqual(
                column.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0, y: 8.0, width: 100, height: 50),
                    CGRect(x: 0, y: 63, width: 100, height: 50),
                    CGRect(x: 0, y: 118, width: 100, height: 50)
                ]
            )
            XCTAssertEqual(column.maxY, 176)
            XCTAssertEqual(column.height, 176)
        }
    }
    
    func test_moveDownwardを実行すると正しい値で値が更新されること() {
        XCTContext.runActivity(named: "") { _ in
            column = Column.create(
                configuration: AdaptiveHeightConfiguration(
                    columnCount: 2,
                    minimumInterItemSpacing: 0,
                    minimumLineSpacing: 5,
                    sectionInsets: UIEdgeInsets(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
                ),
                columnNumber: 0,
                collectionViewWidth: 200
            )
            
            column.addAttributes(
                indexPath: IndexPath(item: 0, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            column.addAttributes(
                indexPath: IndexPath(item: 1, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            column.addAttributes(
                indexPath: IndexPath(item: 2, section: 0),
                itemSize: CGSize(width: 200, height: 100)
            )
            
            XCTAssertEqual(
                column.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0, y: 8.0, width: 100, height: 50),
                    CGRect(x: 0, y: 63, width: 100, height: 50),
                    CGRect(x: 0, y: 118, width: 100, height: 50)
                ]
            )
            XCTAssertEqual(column.originY, 0)
            XCTAssertEqual(column.maxY, 176)
            XCTAssertEqual(column.height, 176)
            
            column.moveDownward(by: 100)
            XCTAssertEqual(
                column.attributesSet.map { $0.frame },
                [
                    CGRect(x: 0, y: 108.0, width: 100, height: 50),
                    CGRect(x: 0, y: 163, width: 100, height: 50),
                    CGRect(x: 0, y: 218, width: 100, height: 50)
                ]
            )
            XCTAssertEqual(column.originY, 100)
            XCTAssertEqual(column.maxY, 276)
            XCTAssertEqual(column.height, 276)
        }
    }
}

fileprivate extension Column {
    class func create(
        configuration: AdaptiveHeightConfiguration = .default,
        section: Int = 0,
        columnNumber: Int = 0,
        collectionViewWidth: CGFloat = 360
    ) -> Column {
        return Column(
            configuration: configuration,
            section: section,
            columnNumber: columnNumber,
            collectionViewWidth: collectionViewWidth
        )
    }
}
